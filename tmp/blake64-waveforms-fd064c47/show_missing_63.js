const fs=require('fs'),assert=require('assert');
const out='C:/Work/assignment_3/wavedrom-compact';
const trace='C:/Work/tmp/blake64-waveforms-fd064c47/63-extended/trace.csv';
const symbols=JSON.parse(fs.readFileSync('C:/Work/assignment_3/wavedrom-verified/signal-values.json'));
const lines=fs.readFileSync(trace,'utf8').trim().split(/\r?\n/), keys=lines.shift().split(',');
const rows=new Map(lines.map(l=>{const r=Object.fromEntries(l.split(',').map((v,i)=>[keys[i],v]));return[+r.half,r];}));
const cycles=[125,126,127,128,129,190,191,252,253,254,383,384,385], slots=[];
cycles.forEach((c,i)=>{if(i&&c!==cycles[i-1]+1)slots.push(null,null);slots.push(2*c,2*c+1);});
const names=['IDLE','RUN_G0','RUN_G1','RUN_BOTH'];
function sym(v,t){if(/^0+$/.test(v))return'0';const key=Object.keys(t).find(k=>t[k]===v);assert(key);return key;}
function color(v){return v==='IV'?'7':v==='RUN_BOTH'||/^[DMH]2$|^T\d+$/.test(v)?'5':v==='RUN_G0'||/^[DMH]0$|^S\d+$/.test(v)?'3':v==='RUN_G1'||/^[DMH]1$/.test(v)?'4':'2';}
let comparisons=0;
function lane(name,get,binary=false,fixed){let wave='',data=[],previous,inGap=false;for(const h of slots){if(h===null){wave+=inGap?'.':'|';inGap=true;continue;}inGap=false;const value=String(get(rows.get(h),h));assert(value!=='undefined');if(value===previous)wave+='.';else if(binary)wave+=value;else{wave+=fixed||color(value);data.push(value);}previous=value;}
 let value,di=0;[...wave].forEach((w,i)=>{if(slots[i]===null)return;if(w==='0'||w==='1')value=w;else if(w!=='.')value=data[di++];assert.strictEqual(value,String(get(rows.get(slots[i]),slots[i])));comparisons++;});assert(binary||di===data.length);
 return{name,wave,...(binary?{}:{data}),period:0.5};}
function state(r){if(r.state_0===r.v0)return'IV';const label='S'+r.steps0;assert.strictEqual(r.state_0,symbols.state_0[label]);return label;}
const obj={signal:[lane('Cycle',(_,h)=>Math.floor(h/2)),lane('clk',r=>r.clk,true),lane('ena',r=>r.ena,true),lane('din',r=>sym(r.din,symbols.inputs)),lane('current state',r=>names[+r.cstate]),lane('counter_g0',r=>r.counter_g0,false,'3'),lane('counter_g1',r=>r.counter_g1,false,'4'),lane('init_g0',r=>r.init_g0,true),lane('msg_g0',r=>sym(r.msg_g0,symbols.messages)),lane('state_0',state),lane('rdy',r=>r.rdy,true),lane('dout',r=>sym(r.dout,symbols.hashes))],head:{text:'63-cycle input: third output missing'},foot:{text:'| = Omitted cycles; no H2 at C253 or C384 (= 128 x 3)'},config:{hscale:1}};
obj.signal.forEach(l=>{assert(l.wave.length===slots.length);assert.deepStrictEqual([...l.wave].flatMap((w,i)=>w==='|'?[i]:[]),[...obj.signal[0].wave].flatMap((w,i)=>w==='|'?[i]:[]));});
const pulses=[...rows].filter(([h,r])=>h>=0&&r.rdy==='1'&&rows.get(h-1).rdy==='0').map(([h])=>h/2);
assert.deepStrictEqual(pulses,[127,190]);
for(const[h,r]of rows){if(h>=382){assert.strictEqual(r.rdy,'0');assert(/^0+$/.test(r.dout));}if(h===252){assert.strictEqual(rows.get(h-1).init_g0,'0');assert.strictEqual(rows.get(h-1).init_g1,'0');}}
const text='{\n  "signal": [\n'+obj.signal.map(s=>'    '+JSON.stringify(s)).join(',\n')+'\n  ],\n  "head": '+JSON.stringify(obj.head)+',\n  "foot": '+JSON.stringify(obj.foot)+',\n  "config": '+JSON.stringify(obj.config)+'\n}';
fs.writeFileSync(out+'/63-detail.json',text+'\n');
let md=fs.readFileSync(out+'/README.md','utf8');
md=md.replace('세부 파형은 C125부터 C132 직전까지 7클럭이며 생략하지 않았습니다.','64/65 세부 파형은 C125부터 C132 직전까지 7클럭이며 생략하지 않았습니다. 63 세부 파형은 입력 누락 구간, 두 번째 출력, 세 번째 출력 예상 시점 C253, C384를 생략 표시로 연결합니다.');
const heading='## 63 cycles — detail';assert(md.includes(heading));md=md.slice(0,md.indexOf(heading))+heading+'\n\n세 번째 입력 시도 C126에서 init_g0=0이므로 M2가 저장되지 않습니다. H0와 H1만 출력되고 C191 이후 C390까지 rdy=0, dout=0입니다. C384=128×3은 추가 대기 확인 지점입니다. C0를 첫 입력 저장 시점으로 잡으면 세 번째 입력이 수락되었을 경우의 출력 시점은 C126+127=C253입니다.\n\n```json\n'+text+'\n```\n';
fs.writeFileSync(out+'/README.md',md);
const validation=JSON.parse(fs.readFileSync(out+'/validation.json'));const item=validation.cases.find(c=>c.gap===63);assert(item);validation.totalHalfClockComparisons+=comparisons-154;item.halfClockComparisons+=comparisons-154;delete item.detailClocks;item.detailDisplayedCycles=cycles;item.extendedSimulationLastCycle=390;item.outputCycles=pulses;item.thirdOutputAbsentThroughCycle=390;validation.visualRenderingChecked=false;
fs.writeFileSync(out+'/validation.json',JSON.stringify(validation,null,2)+'\n');
console.log(text);console.log('Verified '+comparisons+' displayed half-clock samples; output pulses only at '+pulses.join(',')+' through C390.');
