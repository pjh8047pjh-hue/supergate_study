'use strict';
const fs = require('fs');
const path = require('path');
const assert = require('assert');
const root = 'C:/Work/tmp/blake64-waveforms-fd064c47';
let out = 'C:/Work/assignment_3/wavedrom-verified';
if (fs.existsSync(out)) {
  let version = 2;
  while (fs.existsSync(out + '-v' + version)) version++;
  out += '-v' + version;
}
fs.mkdirSync(out, {recursive: true});
const tb = fs.readFileSync('C:/Work/assignment_3/tb_blake_64.v', 'utf8');
const inputs = [];
for (const m of tb.matchAll(/assign md\[(\d)\]\s*=\s*\{([\s\S]*?)\};/g)) {
  inputs[+m[1]] = [...m[2].matchAll(/8'h([0-9a-f]{2})/gi)].map(x => x[1].toLowerCase()).join('');
}
assert(inputs.length === 3 && inputs.every(x => x.length === 160));
const messages = inputs.map(s => s.match(/.{8}/g).map(w => w.match(/../g).reverse().join('')).join(''));
const hashes = [];
for (const m of tb.matchAll(/assign ref\[(\d)\]\s*=\s*512'h([0-9a-f]+)/gi)) hashes[+m[1]] = m[2].toLowerCase();
assert(hashes.length === 3 && hashes.every(x => x.length === 128));
const stateNames = ['IDLE', 'RUN_G0', 'RUN_G1', 'RUN_BOTH'];
const symbolValues = {
  inputs: Object.fromEntries(inputs.map((v, i) => ['D' + i, v])),
  messages: Object.fromEntries(messages.map((v, i) => ['M' + i, v])),
  hashes: Object.fromEntries(hashes.map((v, i) => ['H' + i, v])),
  state_0: {}
};
const reports = [];
const diagrams = [];
const nfields = ['half','clk','rstb','ena','cstate','counter_g0','counter_g1','init_g0','init_g1','cnt_en_g0','cnt_en_g1','done_g0','done_g1','rdy','steps0','steps1'];
function readTrace(gap) {
  const [header, ...lines] = fs.readFileSync(path.join(root, String(gap), 'trace.csv'), 'utf8').trim().split(/\r?\n/);
  const keys = header.split(',');
  return lines.map(line => {
    const parts = line.split(',');
    assert(parts.length === keys.length);
    const row = Object.fromEntries(keys.map((k, i) => [k, nfields.includes(k) ? Number(parts[i]) : parts[i].toLowerCase()]));
    for (const k of nfields) assert(Number.isInteger(row[k]), 'Unknown sampled signal: ' + k);
    return row;
  });
}
function busSymbol(hex, values, prefix) {
  if (/^0+$/.test(hex)) return '0';
  const i = values.indexOf(hex);
  assert(i >= 0, 'Unexpected ' + prefix + ' bus value');
  return prefix + i;
}
function stateSymbol(row) {
  let s;
  if (/^0+$/.test(row.state_0)) s = '0';
  else if (row.state_0 === row.v0) s = 'IV';
  else {
    const mi = messages.indexOf(row.msg_g0);
    assert(mi === 0 || mi === 2);
    s = (mi === 0 ? 'S' : 'T') + row.steps0;
  }
  if (symbolValues.state_0[s]) assert(symbolValues.state_0[s] === row.state_0, 'Inconsistent stored-state label ' + s);
  else symbolValues.state_0[s] = row.state_0;
  return s;
}
function colorFor(v) {
  if (v === 'IDLE' || v === '0') return '2';
  if (v === 'RUN_G0' || /^D0$|^M0$|^H0$|^S\d+$/.test(v)) return '3';
  if (v === 'RUN_G1' || /^D1$|^M1$|^H1$/.test(v)) return '4';
  if (v === 'RUN_BOTH' || /^D2$|^M2$|^H2$|^T\d+$/.test(v)) return '5';
  if (v === 'IV') return '7';
  return '2';
}
function lane(name, values, options={}) {
  let previous;
  let wave = '';
  const data = [];
  for (const v of values) {
    if (v === previous) wave += '.';
    else if (options.binary) wave += String(v);
    else { wave += options.color || colorFor(v); data.push(String(v)); }
    previous = v;
  }
  return {name, wave, ...(options.binary ? {} : {data}),
    ...(options.period === undefined ? {} : {period: options.period}),
    ...(options.phase === undefined ? {} : {phase: options.phase})};
}
function getChanges(rows, key, format=x=>x) {
  let previous;
  return rows.filter(r => r.half % 2 === 0).flatMap(r => {
    const v = format(r[key]);
    if (v === previous) return [];
    previous = v;
    return [{cycle: r.half/2, value:v}];
  });
}
for (const gap of [64, 65, 63]) {
  const rows = readTrace(gap);
  const byHalf = new Map(rows.map(r=>[r.half,r]));
  const first = rows[0];
  function at(h) {
    if (h < first.half) return first;
    assert(byHalf.has(h), 'Sample missing at half-cycle ' + h);
    return byHalf.get(h);
  }
  const arrivals = rows.filter(r=>r.half%2===0 && r.ena && (r.half === 0 || !at(r.half-2).ena)).map(r=>r.half/2);
  assert.deepStrictEqual(arrivals,[0,gap,2*gap]);
  const loads0 = rows.filter(r=>r.half%2===0 && at(r.half-1).init_g0).map(r=>r.half/2);
  const loads1 = rows.filter(r=>r.half%2===0 && at(r.half-1).init_g1).map(r=>r.half/2);
  assert.deepStrictEqual(loads0, gap >= 64 ? [0,2*gap] : [0]);
  assert.deepStrictEqual(loads1, [gap]);
  const resultRows = rows.filter(r=>r.rdy && !at(r.half-1).rdy);
  const resultCycles = resultRows.map(r=>r.half/2);
  assert.deepStrictEqual(resultCycles, gap>=64 ? [127,gap+127,2*gap+127] : [127,gap+127]);
  resultRows.forEach((r,i)=>assert(r.dout===hashes[i]));
  rows.forEach(r=>{
    assert(r.rdy || /^0+$/.test(r.dout));
    if(r.rdy) assert(hashes.includes(r.dout));
  });

  // Full timing: one WaveDrom unit is one real clock cycle.
  // Input lanes are shifted left by half a cycle to match the TB negedge drive.
  const cycles = Array.from({length:262},(_,i)=>i-1);
  const inputCycles = Array.from({length:263},(_,i)=>i-1);
  const node = cycles.map(c=>c===0?'A':c===gap?'B':c===2*gap?'C':'.').join('');
  const overview = {
    signal:[
      {node},
      lane('ena',inputCycles.map(c=>at(2*c-1).ena),{binary:true,phase:0.5}),
      lane('din',inputCycles.map(c=>busSymbol(at(2*c-1).din,inputs,'D')),{phase:0.5}),
      lane('current state',cycles.map(c=>stateNames[at(2*c).cstate])),
      lane('rdy',cycles.map(c=>at(2*c).rdy),{binary:true}),
      lane('dout',cycles.map(c=>busSymbol(at(2*c).dout,hashes,'H')))
    ],
    edge:['A<->B '+gap,'B<->C '+gap],
    head:{text:gap+'-cycle input: full timing (cycle 0 = first captured input)',tick:-1,every:16},
    foot:{text:'True clock scale; no omitted cycles. D = input, H = verified hash.'},
    config:{hscale:1,hbounds:[0,262],marks:false}
  };

  // Common zoom range for all cases: rising edge C124 through just before C134.
  const zoom = rows.filter(r=>r.half>=248 && r.half<268);
  assert(zoom.length === 20);
  const half={period:0.5};
  const detail = {
    signal:[
      {name:'clk',wave:'P.........'},
      lane('ena',zoom.map(r=>r.ena),{binary:true,...half}),
      lane('din',zoom.map(r=>busSymbol(r.din,inputs,'D')),half),
      lane('current state',zoom.map(r=>stateNames[r.cstate]),half),
      lane('counter_g0',zoom.map(r=>r.counter_g0),{color:'3',...half}),
      lane('counter_g1',zoom.map(r=>r.counter_g1),{color:'4',...half}),
      lane('init_g0',zoom.map(r=>r.init_g0),{binary:true,...half}),
      lane('msg_g0',zoom.map(r=>busSymbol(r.msg_g0,messages,'M')),half),
      lane('state_0',zoom.map(stateSymbol),half),
      lane('rdy',zoom.map(r=>r.rdy),{binary:true,...half}),
      lane('dout',zoom.map(r=>busSymbol(r.dout,hashes,'H')),half)
    ],
    head:{text:gap+'-cycle input: third-input detail (C124-C134)',tick:124},
    foot:{text:'1 grid interval = 1 clock. Register values are after the rising edge.'},
    config:{hscale:2}
  };
  for (const [kind, object] of [['overview',overview],['detail',detail]]) {
    const name=gap+'-'+kind;
    const file=path.join(out,name+'.json');
    fs.writeFileSync(file,JSON.stringify(object,null,2)+'\n');
    diagrams.push({name,object});
  }
  const log=fs.readFileSync(path.join(root,String(gap),'simulation.log'),'utf8');
  assert(log.includes('errors=0'));
  fs.copyFileSync(path.join(root,String(gap),'trace.csv'),path.join(out,gap+'-trace.csv'));
  const interesting = rows.filter(r=>r.half%2===0 && r.half>=248 && r.half<=266).map(r=>({
    cycle:r.half/2,ena:r.ena,current_state:stateNames[r.cstate],
    counter_g0:r.counter_g0,counter_g1:r.counter_g1,init_g0:r.init_g0,
    msg_g0:busSymbol(r.msg_g0,messages,'M'),state_0:stateSymbol(r),
    rdy:r.rdy,dout:busSymbol(r.dout,hashes,'H')
  }));
  reports.push({gap,firstInputNs:(gap-1)*10+5,inputCycles:arrivals,
    loadG0:loads0,loadG1:loads1,
    outputCycles:resultCycles,hashes:resultRows.map((r)=>busSymbol(r.dout,hashes,'H')),
    stateChanges:getChanges(rows,'cstate',s=>stateNames[s]),detailSamples:interesting});
}
fs.writeFileSync(path.join(out,'verification.json'),JSON.stringify(reports,null,2)+'\n');
fs.writeFileSync(path.join(out,'signal-values.json'),JSON.stringify(symbolValues,null,2)+'\n');
const md=[];
md.push('# Verified BLAKE-64 WaveDrom diagrams','',
  '현재 C:/Work/assignment_3 RTL을 ModelSim에서 실행하여 추출한 값으로 작성했습니다. 원본 RTL과 TB는 변경하지 않았습니다.',
  '',
  '## 시간축','',
  '- C0: 각 시뮬레이션에서 첫 입력을 저장하는 상승 엣지.',
  '- 전체: C-1부터 C261 직전까지. 1 WaveDrom 단위 = 1 실제 클록. 생략 구간 없음.',
  '- 상세: 세 경우 모두 C124부터 C134 직전까지. 신호 문자열의 한 글자는 0.5클록이며, 격자 간격과 위쪽 숫자는 1클록.',
  '- 입력 ena와 din은 TB와 같이 입력 저장 엣지보다 0.5클록 앞선 하강 엣지에서 변경.',
  '- 상세의 레지스터 값은 상승 엣지 처리 후의 값. init_g0는 입력 저장 엣지 직전에 1인 구간을 확인.',
  '- 상세는 세 번째 입력이 들어오는 G0 경로를 중심으로 표시. 추가한 저장 제어 신호는 init_g0 하나.',
  '',
  '## 기호','',
  '- D0/D1/D2: TB 원본 md[0]/md[1]/md[2].',
  '- M0/M1/M2: 각 D 입력의 32비트 워드별 바이트 순서를 반전하여 저장한 메시지.',
  '- H0/H1/H2: ref[0]/ref[1]/ref[2]와 비트 단위로 일치한 512비트 해시.',
  '- IV: v0와 비트 단위로 일치하는 초기 상태.',
  '- S124 등의 S숫자: D0 메시지에 G 연산을 해당 횟수만큼 반영한 저장 상태.',
  '- T1 등의 T숫자: D2 메시지에 G 연산을 해당 횟수만큼 반영한 저장 상태.',
  '- 이 기호들은 원래 버스 값 자체가 아닌 읽기 쉬운 표기. 실제 16진수 값은 signal-values.json과 각 trace.csv에 보관.',
  '',
  '## 검증 결과','',
  '| 입력 간격 | 입력 저장 클록 | 결과 출력 시작 클록 | 결과 |',
  '|---|---|---|---|');
for(const r of reports) md.push('| '+r.gap+' | '+[...r.loadG0,...r.loadG1].sort((a,b)=>a-b).map(c=>'C'+c).join(', ')+' | '+r.outputCycles.map(c=>'C'+c).join(', ')+' | '+r.hashes.join(', ')+' 일치 |');
md.push('',
  '- 64: C128에서 M0→M2, state_0→IV, counter_g0=0. RUN_BOTH 유지.',
  '- 65: C128에서 RUN_G1로 전이. C130에서 M0→M2, state_0→IV, counter_g0=0, RUN_BOTH 복귀.',
  '- 63: D2는 C126에 제시되지만 init_g0=0이고 G1도 busy이므로 저장되지 않음. M0 유지, state_0는 S128까지 진행 후 유지. H2 없음.',
  '- 63의 세 번째 결과 미출력은 의도적으로 재현한 입력 누락이며 세 번째 해시의 계산 실패가 아님.',
  '- 현재 RTL에는 64 미만을 무조건 차단하는 별도 비교기가 없음. 이 63 사례는 세 입력을 모두 63클록 간격으로 넣은 결과.',
  '',
  '## 사용','',
  '각 JSON 파일의 전체 내용을 WaveDrom 편집기에 붙여넣으세요. 전체도는 실제 262클록 구간을 유지하므로 가로로 길게 렌더링됩니다. 상세도는 보고서용 확대 그림입니다.',
  '',
  '## 전체 코드','');
for(const d of diagrams) md.push('### '+d.name,'','~~~json',JSON.stringify(d.object,null,2),'~~~','');
fs.writeFileSync(path.join(out,'README.md'),md.join('\n')+'\n');
console.log(JSON.stringify({output:out,files:fs.readdirSync(out),results:reports.map(r=>({
  gap:r.gap,inputs:r.inputCycles,acceptedG0:r.loadG0,acceptedG1:r.loadG1,outputs:r.outputCycles,stateChanges:r.stateChanges
}))},null,2));
