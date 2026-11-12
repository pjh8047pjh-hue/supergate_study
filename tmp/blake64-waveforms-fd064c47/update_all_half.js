const fs=require('fs'),assert=require('assert');
const base='C:/Work/assignment_3/wavedrom-verified', out='C:/Work/assignment_3/wavedrom-compact';
const symbols=JSON.parse(fs.readFileSync(base+'/signal-values.json'));
const reports=JSON.parse(fs.readFileSync(base+'/verification.json'));
const names=['IDLE','RUN_G0','RUN_G1','RUN_BOTH'];
function sym(v,t){if(/^0+$/.test(v))return'0';const k=Object.keys(t).find(k=>t[k]===v);assert(k,'Unknown bus value');return k;}
function color(v){return v==='IV'?'7':v==='RUN_BOTH'||/^[DMHT]2$|^T\d+$/.test(v)?'5':v==='RUN_G0'||/^[DMH]0$|^S\d+$/.test(v)?'3':v==='RUN_G1'||/^[DMH]1$/.test(v)?'4':'2';}
let total=0;
function lane(name,slots,get,binary=false,fixedColor){let wave='',previous,inGap=false,data=[];for(const h of slots){if(h===null){wave+=inGap?'.':'|';inGap=true;continue;}inGap=false;const v=String(get(h));assert(v!=='undefined');if(v===previous)wave+='.';else if(binary)wave+=v;else{wave+=fixedColor||color(v);data.push(v);}previous=v;}
 // Decode the delivered strings and compare every retained half-clock to the CSV.
 let di=0,value;[...wave].forEach((w,i)=>{if(slots[i]===null)return;if(w==='0'||w==='1')value=w;else if(w!=='.')value=data[di++];assert.strictEqual(value,String(get(slots[i])),name+' @ half '+slots[i]);total++;});assert(binary||di===data.length);
 return{name,wave,...(binary?{}:{data}),period:0.5};}
function format(obj){return'{\n  "signal": [\n'+obj.signal.map(s=>'    '+JSON.stringify(s)).join(',\n')+'\n  ],\n  "head": '+JSON.stringify(obj.head)+',\n  "foot": '+JSON.stringify(obj.foot)+',\n  "config": '+JSON.stringify(obj.config)+'\n}';}
let readme='# WaveDrom timing diagrams\n\n모든 행은 period: 0.5이며 한 글자가 반 클럭입니다.\n전체 파형의 |는 생략 구간이며, 모든 행에서 같은 위치에 있습니다. Cycle 숫자 하나는 한 클럭 폭입니다. 전체 파형은 불균일하게 생략되어 있으므로 Cycle 행으로 실제 시점을 확인합니다.\n세부 파형은 C125부터 C132 직전까지 7클럭이며 생략하지 않았습니다.\nC0는 첫 번째 입력을 저장한 상승 에지입니다. ena와 din은 하강 에지에서 바뀝니다.\n\nD0/D1/D2: 입력, M0/M2: 저장된 메시지, H0/H1/H2: 검증된 해시, IV: 초기 상태.\nSn: 첫 입력에 대해 n회 G 연산 후 저장된 상태. Tn: 세 번째 입력에 대해 n회 G 연산 후 저장된 상태.\n\n64: 입력 C0/C64/C128, 출력 C127/C191/C255.\n65: 입력 C0/C65/C130, 출력 C127/C192/C257.\n63: 입력 시도 C0/C63/C126, 세 번째 입력은 무시되며 출력은 C127/C190의 두 개입니다.\n\n';
const validation=[];
for(const gap of [64,65,63]){
 const lines=fs.readFileSync(base+'/'+gap+'-trace.csv','utf8').trim().split(/\r?\n/), keys=lines.shift().split(',');
 const rows=new Map(lines.map(l=>{const r=Object.fromEntries(l.split(',').map((v,i)=>[keys[i],v]));return[+r.half,r];}));
 const report=reports.find(r=>r.gap===gap), keep=new Set([-1,0,1,gap-1,gap,gap+1,2*gap-1,2*gap,2*gap+1]);
 report.outputCycles.forEach(c=>{keep.add(c);keep.add(c+1);});report.stateChanges.forEach(e=>keep.add(e.cycle));
 const cycles=[...keep].sort((a,b)=>a-b), overviewSlots=[];
 cycles.forEach((c,i)=>{if(i&&c!==cycles[i-1]+1)overviewSlots.push(null,null);overviewSlots.push(2*c,2*c+1);});
 const before=total;
 const overview={signal:[lane('Cycle',overviewSlots,h=>Math.floor(h/2)),lane('ena',overviewSlots,h=>rows.get(h).ena,true),lane('rdy',overviewSlots,h=>rows.get(h).rdy,true),lane('dout',overviewSlots,h=>sym(rows.get(h).dout,symbols.hashes)),lane('din',overviewSlots,h=>sym(rows.get(h).din,symbols.inputs)),lane('current state',overviewSlots,h=>names[+rows.get(h).cstate])],head:{text:'Input interval = '+gap+' cycles'},foot:{text:'| = Omitted cycles'},config:{hscale:1}};
 const zoom=Array.from({length:14},(_,i)=>250+i), r=h=>rows.get(h);
 function state(h){const a=r(h);if(/^0+$/.test(a.state_0))return'0';if(a.state_0===a.v0)return'IV';const m=sym(a.msg_g0,symbols.messages);assert(m==='M0'||m==='M2');const s=(m==='M0'?'S':'T')+a.steps0;assert.strictEqual(a.state_0,symbols.state_0[s]);return s;}
 const detail={signal:[lane('clk',zoom,h=>r(h).clk,true),lane('ena',zoom,h=>r(h).ena,true),lane('din',zoom,h=>sym(r(h).din,symbols.inputs)),lane('current state',zoom,h=>names[+r(h).cstate]),lane('counter_g0',zoom,h=>r(h).counter_g0,false,'3'),lane('counter_g1',zoom,h=>r(h).counter_g1,false,'4'),lane('init_g0',zoom,h=>r(h).init_g0,true),lane('msg_g0',zoom,h=>sym(r(h).msg_g0,symbols.messages)),lane('state_0',zoom,state),lane('rdy',zoom,h=>r(h).rdy,true),lane('dout',zoom,h=>sym(r(h).dout,symbols.hashes))],head:{text:gap+'-cycle input: third-input detail',tick:125},foot:{text:'1 grid = 1 clock; C125-C132'},config:{hscale:2}};
 for(const[kind,obj]of[['overview',overview],['detail',detail]]){
  assert(obj.signal.every(l=>l.period===0.5&&l.wave.length===obj.signal[0].wave.length));
  const gaps=obj.signal[0].wave.split('').flatMap((v,i)=>v==='|'?[i]:[]);
  obj.signal.forEach(l=>assert.deepStrictEqual(l.wave.split('').flatMap((v,i)=>v==='|'?[i]:[]),gaps));
  const text=format(obj);fs.writeFileSync(out+'/'+gap+'-'+kind+'.json',text+'\n');
  if(gap===64&&kind==='overview')fs.writeFileSync(out+'/64-half-aligned.json',text+'\n');
  readme+='## '+gap+' cycles — '+kind+'\n\n```json\n'+text+'\n```\n\n';
 }
 validation.push({gap,overviewHalfSlots:overviewSlots.length,detailClocks:7,halfClockComparisons:total-before,mismatches:0});
}
fs.writeFileSync(out+'/README.md',readme);
fs.writeFileSync(out+'/validation.json',JSON.stringify({totalHalfClockComparisons:total,mismatches:0,cases:validation,visualRenderingChecked:false},null,2)+'\n');
console.log(JSON.stringify({totalHalfClockComparisons:total,cases:validation}));
