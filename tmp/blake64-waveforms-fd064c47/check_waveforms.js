'use strict';
const fs=require('fs');
const path=require('path');
const assert=require('assert');
const base='C:/Work/assignment_3/wavedrom-verified';
const values=JSON.parse(fs.readFileSync(path.join(base,'signal-values.json'),'utf8'));
const stateHex=Object.fromEntries(Object.entries(values.state_0).map(([k,v])=>[v,k]));
const stateNames=['IDLE','RUN_G0','RUN_G1','RUN_BOTH'];
let comparisons=0;
function decode(lane) {
  if(!lane.wave) return null;
  const isBus=Array.isArray(lane.data);
  let current,di=0;
  const result=[];
  const repeat=2*(lane.period || 1);
  assert(Number.isInteger(repeat) && repeat>0);
  if(lane.wave[0]==='P') {
    assert(repeat===2);
    for(const x of lane.wave) {
      assert(x==='P' || x==='.');
      result.push('1','0');
    }
  } else {
    for(const x of lane.wave) {
      if(x!=='.') {
        if(isBus) current=String(lane.data[di++]);
        else {
          assert(x==='0'||x==='1');
          assert(x!==current,'Repeated binary digit would draw an unwanted transition');
          current=x;
        }
      }
      assert(current!==undefined);
      for(let i=0;i<repeat;i++) result.push(current);
    }
    if(isBus) assert(di===lane.data.length);
  }
  return result.slice(Math.max(0,Math.round(2*(lane.phase || 0))));
}
function readTrace(gap) {
  const [h,...lines]=fs.readFileSync(path.join(base,gap+'-trace.csv'),'utf8').trim().split(/\r?\n/);
  const keys=h.split(',');
  return new Map(lines.map(line=>{
    const p=line.split(',');
    const r=Object.fromEntries(keys.map((k,i)=>[k,p[i].toLowerCase()]));
    return [+r.half,r];
  }));
}
function rawExpected(name,row) {
  if(name==='current state')return stateNames[+row.cstate];
  if(name==='din')return /^0+$/.test(row.din)?'0':Object.keys(values.inputs).find(k=>values.inputs[k]===row.din);
  if(name==='dout')return /^0+$/.test(row.dout)?'0':Object.keys(values.hashes).find(k=>values.hashes[k]===row.dout);
  if(name==='msg_g0')return /^0+$/.test(row.msg_g0)?'0':Object.keys(values.messages).find(k=>values.messages[k]===row.msg_g0);
  if(name==='state_0')return stateHex[row.state_0];
  return row[name];
}
const report=[];
for(const gap of [64,65,63]) {
  const trace=readTrace(gap);
  for(const kind of ['overview','detail']) {
    const obj=JSON.parse(fs.readFileSync(path.join(base,gap+'-'+kind+'.json'),'utf8'));
    const start=kind==='overview'?-2:248;
    const n=kind==='overview'?524:20;
    let checked=0;
    for(const lane of obj.signal) {
      if(!lane.wave)continue;
      const data=decode(lane);
      assert(data.length>=n,lane.name+' lane too short');
      for(let i=0;i<n;i++) {
        const row=trace.get(start+i);
        const expected=rawExpected(lane.name,row);
        assert(expected!==undefined);
        assert(data[i]===String(expected),'Mismatch: gap='+gap+' '+kind+' '+lane.name+' C'+((start+i)/2)+' got '+data[i]+' expected '+expected);
        checked++;
      }
    }
    if(kind==='overview') {
      const node=obj.signal[0].node;
      assert(node.indexOf('B')-node.indexOf('A')===gap);
      assert(node.indexOf('C')-node.indexOf('B')===gap);
    }
    comparisons+=checked;
    report.push({gap,kind,halfCycleSamples:n,signalSampleComparisons:checked,mismatches:0});
  }
}
fs.writeFileSync(path.join(base,'waveform-validation.json'),JSON.stringify({comparisons,report},null,2)+'\n');
console.log(JSON.stringify({comparisons,mismatches:0,report},null,2));
