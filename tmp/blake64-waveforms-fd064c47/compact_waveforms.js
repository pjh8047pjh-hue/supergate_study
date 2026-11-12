const fs=require('fs'), assert=require('assert');
const base='C:/Work/assignment_3/wavedrom-verified';
const out='C:/Work/assignment_3/wavedrom-compact';
fs.mkdirSync(out,{recursive:true});
const symbols=JSON.parse(fs.readFileSync(base+'/signal-values.json','utf8'));
const reports=JSON.parse(fs.readFileSync(base+'/verification.json','utf8'));
const names=['IDLE','RUN_G0','RUN_G1','RUN_BOTH'];
function symbol(hex,table){if(/^0+$/.test(hex))return '0';const v=Object.entries(table).find(([k,h])=>h===hex);assert(v);return v[0];}
function color(v){return v==='RUN_BOTH'||/^[DMH]2$/.test(v)?'5':v==='RUN_G0'||/^[DMH]0$/.test(v)?'3':v==='RUN_G1'||/^[DMH]1$/.test(v)?'4':'2';}
function lane(name,slots,get,binary=false){let prev,wave='',data=[];for(const s of slots){if(s===null){wave+='|';continue;}const v=String(get(s));if(v===prev)wave+='.';else if(binary)wave+=v;else{wave+=color(v);data.push(v);}prev=v;}return{name,wave,...(binary?{}:{data})};}
function compactJSON(obj){return '{\n  "signal": [\n'+obj.signal.map(s=>'    '+JSON.stringify(s)).join(',\n')+'\n  ],\n  "head": '+JSON.stringify(obj.head)+',\n  "foot": '+JSON.stringify(obj.foot)+',\n  "config": '+JSON.stringify(obj.config)+'\n}';}
let md='전체: 상승 에지 직후 값만 표시. |는 중간 클럭 생략. Cycle 행은 실제 상대 클럭 번호.\n세부: C125~C132, 1 grid = 1 clock, 반 클럭 변화까지 표시.\nD=input, M=stored message, H=hash, IV=initial state, Sn=D0 after n updates, Tn=D2 after n updates.\n\n';
for(const gap of [64,65,63]){
 const lines=fs.readFileSync(base+'/'+gap+'-trace.csv','utf8').trim().split(/\r?\n/);const keys=lines.shift().split(',');
 const rows=new Map(lines.map(l=>{const r=Object.fromEntries(l.split(',').map((v,i)=>[keys[i],v]));return[Number(r.half),r];}));
 const report=reports.find(x=>x.gap===gap);
 const keep=new Set([-1,0,1,gap-1,gap,gap+1,2*gap-1,2*gap,2*gap+1]);
 for(const c of report.outputCycles){keep.add(c);keep.add(c+1);}
 for(const e of report.stateChanges)keep.add(e.cycle);
 const sorted=[...keep].sort((a,b)=>a-b), slots=[];
 for(const c of sorted){if(slots.length&&c>slots[slots.length-1]+1)slots.push(null);slots.push(c);}
 const r=c=>rows.get(2*c);
 const overview={signal:[
  lane('Cycle',slots,c=>c),
  lane('ena',slots,c=>r(c).ena,true),
  lane('din',slots,c=>symbol(r(c).din,symbols.inputs)),
  lane('current state',slots,c=>names[+r(c).cstate]),
  lane('rdy',slots,c=>r(c).rdy,true),
  lane('dout',slots,c=>symbol(r(c).dout,symbols.hashes))
 ],head:{text:gap+'-cycle input: overview'},foot:{text:'Rising-edge samples; | = omitted cycles'},config:{hscale:1}};
 // Decode each compact lane and independently compare every retained sample.
 let checks=0;
 const expected=[c=>String(c),c=>r(c).ena,c=>symbol(r(c).din,symbols.inputs),c=>names[+r(c).cstate],c=>r(c).rdy,c=>symbol(r(c).dout,symbols.hashes)];
 overview.signal.forEach((l,i)=>{assert(l.wave.length===slots.length);let value,di=0;l.wave.split('').forEach((w,j)=>{if(w==='|'){assert(slots[j]===null);return;}if(w==='0'||w==='1')value=w;else if(w!=='.')value=l.data[di++];assert.strictEqual(value,expected[i](slots[j]));checks++;});if(l.data)assert(di===l.data.length);});
 // Trim existing half-clock-accurate detail from C124..134 to C125..132.
 const old=JSON.parse(fs.readFileSync(base+'/'+gap+'-detail.json','utf8'));
 const detail={...old,signal:old.signal.map((l,i)=>{if(i===0)return{...l,wave:'P......'};let value,di=0;const vals=[];for(const w of l.wave){if(w==='0'||w==='1')value=w;else if(w!=='.')value=l.data[di++];vals.push(value);}const selected=vals.slice(2,16);let previous,wave='',data=[];for(const v of selected){if(v===previous)wave+='.';else if(!l.data)wave+=v;else{wave+=color(v)==='2'&&l.name==='counter_g0'?'3':color(v)==='2'&&l.name==='counter_g1'?'4':v==='IV'?'7':/^S/.test(v)?'3':/^T/.test(v)?'5':color(v);data.push(v);}previous=v;}return{name:l.name,wave,...(l.data?{data}:{}),period:0.5};}),head:{text:gap+'-cycle input: third-input detail',tick:125},foot:{text:'1 grid = 1 clock; C125-C132'},config:{hscale:2}};
 for(const [kind,obj]of[['overview',overview],['detail',detail]]){const txt=compactJSON(obj);fs.writeFileSync(out+'/'+gap+'-'+kind+'.json',txt+'\n');md+='**'+gap+' cycles — '+kind+'**\n\n```json\n'+txt+'\n```\n\n';}
 console.log(gap+': overview '+slots.length+' slots, detail 7 clocks; '+checks+' retained-sample checks passed');
}
fs.writeFileSync(out+'/README.md',md);
