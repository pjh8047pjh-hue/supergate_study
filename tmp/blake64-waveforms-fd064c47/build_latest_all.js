const fs=require('fs'),assert=require('assert');
const task='C:/Work/tmp/blake64-waveforms-fd064c47',out='C:/Work/assignment_3/wavedrom-compact';
const symbols=JSON.parse(fs.readFileSync('C:/Work/assignment_3/wavedrom-verified/signal-values.json'));
const reports=JSON.parse(fs.readFileSync('C:/Work/assignment_3/wavedrom-verified/verification.json'));
const names=['IDLE','RUN_G0','RUN_G1','RUN_BOTH'];
const sym=(v,t)=>{if(/^0+$/.test(v))return'0';const k=Object.keys(t).find(k=>t[k]===v);assert(k);return k;};
const color=v=>v==='IV'?'7':v==='RUN_BOTH'||/^[DMH]2$|^T\d+$/.test(v)?'5':v==='RUN_G0'||/^[DMH]0$|^S\d+$/.test(v)?'3':v==='RUN_G1'||/^[DMH]1$/.test(v)?'4':'2';
let count=0;
function lane(name,slots,get,binary=false,fixed){let wave='',previous,inGap=false,data=[];for(const h of slots){if(h===null){wave+=inGap?'.':'|';inGap=true;continue;}inGap=false;const v=String(get(h));assert(v!=='undefined');if(v===previous)wave+='.';else if(binary)wave+=v;else{wave+=fixed||color(v);data.push(v);}previous=v;}
 let di=0,value;[...wave].forEach((w,i)=>{if(slots[i]===null)return;if(w==='0'||w==='1')value=w;else if(w!=='.')value=data[di++];assert.strictEqual(value,String(get(slots[i])),name+' at half '+slots[i]);count++;});assert(binary||di===data.length);
 return{name,wave,...(binary?{}:{data}),period:0.5};}
function slotsFor(cycles){const slots=[];cycles.forEach((c,i)=>{if(i&&c!==cycles[i-1]+1)slots.push(null,null);slots.push(2*c,2*c+1);});return slots;}
function format(obj){return'{\n  "signal": [\n'+obj.signal.map(s=>'    '+JSON.stringify(s)).join(',\n')+'\n  ],\n  "head": '+JSON.stringify(obj.head)+',\n  "foot": '+JSON.stringify(obj.foot)+',\n  "config": '+JSON.stringify(obj.config)+'\n}';}
let md='# WaveDrom: latest complete set\n\n64/65/63클럭 각각 전체와 세부 파형입니다. 세 경우 모두 C390까지 시뮬레이션했습니다.\n모든 행은 period: 0.5로 통일했습니다. 한 글자는 반 클럭, Cycle 숫자 하나는 한 클럭 폭입니다. | 위치는 같은 그림의 모든 행에서 일치합니다. 중간 클럭은 생략하므로 실제 시점은 Cycle 행으로 확인합니다.\n\nC0는 첫 입력을 저장한 상승 에지입니다. ena와 din은 하강 에지에서 바뀝니다. C384=128×3은 추가 대기 확인 지점이며, 입력 파이프라인의 세 번째 출력 예정 시점과는 다릅니다.\n\n| Input interval | Input attempts | Verified outputs |\n|---|---|---|\n|64|C0, C64, C128|H0 at C127, H1 at C191, H2 at C255|\n|65|C0, C65, C130|H0 at C127, H1 at C192, H2 at C257|\n|63|C0, C63, C126|H0 at C127, H1 at C190; no H2|\n\n63클럭의 세 번째 입력은 C126에 저장되지 않습니다. 수락되었다면 예상되는 출력 시점은 C253이며, 이 시점과 C384 이후에도 H2가 없음을 표시했습니다. 64/65클럭은 H2 출력 후 C384에서 이미 IDLE 상태입니다.\n\n세부 파형은 네 구간을 연결합니다: C125~C131(세 번째 입력과 H0), H1 전후 3클럭, H2 예상 시점 전후 3클럭, C383~C385. 세 경우 모두 같은 화면 폭입니다.\nD0/D1/D2: 실제 입력. M0/M2: 저장된 메시지. H0/H1/H2: 기준값과 일치한 해시. IV: 초기 상태. Sn/Tn: 첫 입력/세 번째 입력의 G 연산 n회 후 저장된 상태. 실제 버스 값은 signal-values.json에 있습니다.\n\n';
const results=[];
for(const gap of [64,65,63]){
 const lines=fs.readFileSync(task+'/'+gap+'-extended/trace.csv','utf8').trim().split(/\r?\n/), keys=lines.shift().split(',');
 const rows=new Map(lines.map(l=>{const r=Object.fromEntries(l.split(',').map((v,i)=>[keys[i],v]));return[+r.half,r];})), r=h=>rows.get(h);
 const report=reports.find(x=>x.gap===gap), before=count;
 const pulses=[...rows].filter(([h,a])=>h>=0&&a.rdy==='1'&&r(h-1).rdy==='0').map(([h])=>h/2);
 assert.deepStrictEqual(pulses,report.outputCycles);
 pulses.forEach((c,i)=>assert.strictEqual(r(2*c).dout,symbols.hashes['H'+i]));
 for(const[h,a]of rows){if(a.rdy==='0')assert(/^0+$/.test(a.dout));if(h>=2*(report.outputCycles.at(-1)+1)){assert.strictEqual(a.rdy,'0');assert(/^0+$/.test(a.dout));}if(h>=766)assert.strictEqual(a.cstate,'0');}
 for(const [field,expected]of[['init_g0',report.loadG0],['init_g1',report.loadG1]])assert.deepStrictEqual([...rows].filter(([h])=>h>=0&&h%2===0&&r(h-1)[field]==='1').map(([h])=>h/2),expected);
 assert(fs.readFileSync(task+'/'+gap+'-extended/simulation.log','utf8').includes('errors=0'));
 const keep=new Set([-1,0,1,gap-1,gap,gap+1,2*gap-1,2*gap,2*gap+1,383,384,385]);
 report.outputCycles.forEach(c=>{keep.add(c);keep.add(c+1);});report.stateChanges.forEach(e=>keep.add(e.cycle));
 // In the 63 case, include the missing H2 slot in the overall picture too.
 if(gap===63){keep.add(252);keep.add(253);keep.add(254);}
 const cycles=[...keep].sort((a,b)=>a-b), overall=slotsFor(cycles);
 const overview={signal:[lane('Cycle',overall,h=>Math.floor(h/2)),lane('ena',overall,h=>r(h).ena,true),lane('rdy',overall,h=>r(h).rdy,true),lane('dout',overall,h=>sym(r(h).dout,symbols.hashes)),lane('din',overall,h=>sym(r(h).din,symbols.inputs)),lane('current state',overall,h=>names[+r(h).cstate])],head:{text:'Input interval = '+gap+' cycles'},foot:{text:gap===63?'| = Omitted cycles; H2 missing at C253 and through C384':'| = Omitted cycles; all three hashes completed before C384'},config:{hscale:1}};
 const detailCycles=[125,126,127,128,129,130,131,gap+126,gap+127,gap+128,2*gap+126,2*gap+127,2*gap+128,383,384,385], zoom=slotsFor(detailCycles);
 function state(h){const a=r(h);if(/^0+$/.test(a.state_0))return'0';if(a.state_0===a.v0)return'IV';const m=sym(a.msg_g0,symbols.messages);assert(m==='M0'||m==='M2');const label=(m==='M0'?'S':'T')+a.steps0;if(symbols.state_0[label])assert.strictEqual(symbols.state_0[label],a.state_0);else symbols.state_0[label]=a.state_0;return label;}
 const detail={signal:[lane('Cycle',zoom,h=>Math.floor(h/2)),lane('clk',zoom,h=>r(h).clk,true),lane('ena',zoom,h=>r(h).ena,true),lane('din',zoom,h=>sym(r(h).din,symbols.inputs)),lane('current state',zoom,h=>names[+r(h).cstate]),lane('counter_g0',zoom,h=>r(h).counter_g0,false,'3'),lane('counter_g1',zoom,h=>r(h).counter_g1,false,'4'),lane('init_g0',zoom,h=>r(h).init_g0,true),lane('msg_g0',zoom,h=>sym(r(h).msg_g0,symbols.messages)),lane('state_0',zoom,state),lane('rdy',zoom,h=>r(h).rdy,true),lane('dout',zoom,h=>sym(r(h).dout,symbols.hashes))],head:{text:gap+'-cycle input: '+(gap===63?'third output missing':'third input and all three outputs')},foot:{text:gap===63?'| = Omitted cycles; no H2 at C253 or C384 (= 128 x 3)':'| = Omitted cycles; H2 at C'+(2*gap+127)+'; IDLE at C384 (= 128 x 3)'},config:{hscale:1}};
 for(const[kind,obj]of[['overview',overview],['detail',detail]]){
  const width=obj.signal[0].wave.length,gaps=[...obj.signal[0].wave].flatMap((w,i)=>w==='|'?[i]:[]);
  obj.signal.forEach(l=>{assert(l.period===0.5&&l.wave.length===width);assert.deepStrictEqual([...l.wave].flatMap((w,i)=>w==='|'?[i]:[]),gaps);});
  const text=format(obj);fs.writeFileSync(out+'/'+gap+'-'+kind+'.json',text+'\n');if(gap===64&&kind==='overview')fs.writeFileSync(out+'/64-half-aligned.json',text+'\n');
  md+='## '+gap+' cycles — '+kind+'\n\n```json\n'+text+'\n```\n\n';
 }
 results.push({gap,outputCycles:pulses,simulationLastCycle:390,overviewCycles:cycles,detailCycles,overviewWidthClocks:overall.length/2,detailWidthClocks:zoom.length/2,halfClockComparisons:count-before,mismatches:0});
}
fs.writeFileSync(out+'/README.md',md);fs.writeFileSync(out+'/signal-values.json',JSON.stringify(symbols,null,2)+'\n');
fs.writeFileSync(out+'/validation.json',JSON.stringify({revision:'all-cases-third-output-and-C384',totalHalfClockComparisons:count,mismatches:0,cases:results,visualRenderingChecked:false},null,2)+'\n');
console.log(JSON.stringify({comparisons:count,cases:results.map(r=>({gap:r.gap,outputs:r.outputCycles,overviewClocks:r.overviewWidthClocks,detailClocks:r.detailWidthClocks}))}));
