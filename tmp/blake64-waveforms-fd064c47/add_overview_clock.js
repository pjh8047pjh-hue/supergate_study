const fs=require('fs'),assert=require('assert');
const out='C:/Work/assignment_3/wavedrom-compact', task='C:/Work/tmp/blake64-waveforms-fd064c47';
const format=o=>'{\n  "signal": [\n'+o.signal.map(l=>'    '+JSON.stringify(l)).join(',\n')+'\n  ],\n  "head": '+JSON.stringify(o.head)+',\n  "foot": '+JSON.stringify(o.foot)+',\n  "config": '+JSON.stringify(o.config)+'\n}';
let md=fs.readFileSync(out+'/README.md','utf8');
const validation=JSON.parse(fs.readFileSync(out+'/validation.json','utf8'));
let added=0;
for(const gap of [64,65,63]){
 const file=out+'/'+gap+'-overview.json', obj=JSON.parse(fs.readFileSync(file,'utf8'));
 const cycle=obj.signal.find(l=>l.name==='Cycle');assert(cycle.period===0.5);
 const csv=fs.readFileSync(task+'/'+gap+'-extended/trace.csv','utf8').trim().split(/\r?\n/), fields=csv.shift().split(',');
 const rows=new Map(csv.map(line=>{const r=Object.fromEntries(line.split(',').map((v,i)=>[fields[i],v]));return[+r.half,r];}));
 let wave='',di=0,currentCycle,half=0,inGap=false,checks=0;
 for(const w of cycle.wave){if(w==='|'){wave+='|';inGap=true;continue;}if(inGap&&w==='.'){wave+='.';inGap=false;continue;}if(w!=='.'){currentCycle=+cycle.data[di++];half=0;}const v=rows.get(currentCycle*2+half).clk;assert(v==='0'||v==='1');assert.strictEqual(v,half===0?'1':'0');wave+=v;half++;checks++;}
 assert(di===cycle.data.length);assert(wave.length===cycle.wave.length);
 const existing=obj.signal.findIndex(l=>l.name==='clk');if(existing>=0)obj.signal.splice(existing,1);
 obj.signal.splice(1,0,{name:'clk',wave,period:0.5});
 const positions=l=>[...l.wave].flatMap((w,i)=>w==='|'?[i]:[]);
 for(const l of obj.signal){assert(l.wave.length===wave.length&&l.period===0.5);assert.deepStrictEqual(positions(l),positions(cycle));}
 const text=format(obj);fs.writeFileSync(file,text+'\n');
 if(gap===64)fs.writeFileSync(out+'/64-half-aligned.json',text+'\n');
 const heading='## '+gap+' cycles — overview', start=md.indexOf(heading);assert(start>=0);const bodyStart=md.indexOf('```json\n',start)+8, bodyEnd=md.indexOf('\n```',bodyStart);assert(bodyEnd>bodyStart);md=md.slice(0,bodyStart)+text+md.slice(bodyEnd);
 const record=validation.cases.find(c=>c.gap===gap);if(!record.overviewClockComparisons){record.halfClockComparisons+=checks;added+=checks;}record.overviewClockComparisons=checks;
 console.log(gap+' overview: Cycle + clk, '+checks+' clock samples match simulation');
}
md=md.replace('# WaveDrom: latest complete set','# WaveDrom: Cycle and clk complete set');
if(!md.includes('전체 파형은 Cycle 바로 아래에 clk을 함께 표시합니다.'))md=md.replace('\n\n64/65/63클럭','\n\n전체 파형은 Cycle 바로 아래에 clk을 함께 표시합니다.\n\n64/65/63클럭');
fs.writeFileSync(out+'/README.md',md);
validation.totalHalfClockComparisons+=added;validation.revision='all-cases-cycle-and-clk-third-output-and-C384';
fs.writeFileSync(out+'/validation.json',JSON.stringify(validation,null,2)+'\n');
