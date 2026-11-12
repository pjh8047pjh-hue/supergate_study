const fs = require('fs');
const path = require('path');
const crypto = require('crypto');
const root = 'C:/Work/assignment_6/i2c_rx_assignment/design/rtl';
const backup = 'C:/Work/.tmp/i2c_order_before';
fs.mkdirSync(backup, {recursive:true});
const groups = {
ass_i2c_slave: ['Clock and reset:clk_1 clk_2 rstb','I2C input:scl','I2C bus:sda'],
ass_i2c_slave_serdes: ['Clock and reset:clk rstb','I2C inputs:scl sda','RX FIFO status:rx_full','TX FIFO inputs:tx_empty tx_rdata_in','Handshake input:ack_out_req','Transfer events:start stop_nack req','RX FIFO outputs:rx_wen rx_wdata','TX FIFO output:tx_ren','I2C output:sda_oe'],
ass_i2c_slave_serdes_fsm: ['Clock and reset:clk rstb','I2C events:start stop scl_rise scl_fall ack_bit','Counter input:cnt_scl','RX inputs:rx_full rx_wdata','TX inputs:tx_empty tx_rdata','Handshake inputs:ack_req_sync ack_start_sync ack_stop_sync','Counter controls:init_0 cnt_inc cnt_max','RX controls:rx_en rx_wen','TX control:tx_ren','Transfer events:stop_nack req','I2C output:sda_oe'],
ass_i2c_slave_serdes_cdc: ['Clock and reset:clk rstb','Asynchronous acknowledgements:ack_out_req ack_out_start ack_out_stop','Synchronized acknowledgements:ack_req_sync ack_start_sync ack_stop_sync'],
cdc_handshake_sync: ['Clock and reset:clk rstb','Asynchronous request:req_in','Synchronized outputs:ack_out req_pulse'],
ass_i2c_slave_pkg_dec: ['Clock and reset:clk rstb','Transfer events:start stop_nack req','RX FIFO inputs:rx_empty rx_rdata','TX FIFO status:tx_full','Register file input:rdata','Handshake output:ack_out_req','RX FIFO control:rx_ren','TX FIFO outputs:tx_wen tx_wdata','Register file outputs:we addr wdata'],
ass_i2c_slave_pkg_dec_fsm: ['Clock and reset:clk rstb','Transfer events:start stop_nack req','FIFO status:rx_empty tx_full','FIFO controls:rx_ren tx_wen','Register file controls:waddr_en addr_inc we'],
ass_i2c_slave_scl_counter: ['Clock and reset:clk rstb','Counter controls:init_0 cnt_inc cnt_max','Counter output:cnt_scl'],
ass_i2c_slave_rf: ['Clock:clk','Write control:we','Register file inputs:addr wdata','Register file output:rdata'],
ass_i2c_slave_rf_v2: ['Clock:clk','Write control:we','Register file inputs:addr wdata','Register file output:rdata'],
ass_i2c_slave_rx: ['Clock and reset:clk rstb','I2C inputs:scl sda','Register file input:rdata','I2C output:sda_oe','Register file outputs:we addr wdata'],
ass_i2c_slave_rx_ctrl: ['Clock and reset:clk rstb','I2C inputs:scl sda','Data inputs:wdata rdata','I2C outputs:sda_d2 sda_oe','RX controls:init_addr rx_en','Register file controls:addr_inc we'],
edge_detecter: ['Clock and reset:clk rstb','I2C inputs:scl sda','Transfer events:start stop','SCL edges:scl_rise scl_fall','SDA edges:sda_rise sda_fall','Synchronized samples:scl_d2 sda_d2'],
two_level_1bit_synchronizer: ['Clock:clk','Asynchronous input:data_in','Synchronized output:data_out'],
};
const files = fs.readdirSync(root).filter(n=>n.endsWith('.v'));
const original = Object.fromEntries(files.map(n=>[n,fs.readFileSync(path.join(root,n),'latin1')]));
for(const [n,s] of Object.entries(original)) {
  if(fs.existsSync(path.join(backup,n))) throw Error('Backup already exists: '+n);
  fs.writeFileSync(path.join(backup,n),s,'latin1');
}
const orders = {};
const moduleInfo = {};
function matching(s,start){let depth=0;for(let i=start;i<s.length;i++){if(s[i]==='(')depth++;if(s[i]===')'&&!--depth)return i;}throw Error('Unbalanced parentheses');}
function norm(s){return s.replace(/\/\/[^\n]*|\/\*[\s\S]*?\*\//g,'').replace(/\s+/g,'');}
function headerInfo(s){const m=/\bmodule\s+(\w+)\s*/.exec(s);let pos=m.index+m[0].length;if(s[pos]==='#'){pos=s.indexOf('(',pos);pos=matching(s,pos)+1;while(/\s/.test(s[pos]))pos++;}const end=matching(s,pos);return {name:m[1],start:pos,end};}
function formatDecl(raw,indent=''){
 const m=/^(input|output|inout|wire|reg)\s+(?:(wire|reg)\s+)?(\[[^\]]+\]\s*)?(.*)$/.exec(raw.trim());
 if(!m)return indent+raw.trim();
 return indent+m[1].padEnd(7)+(m[2]||'').padEnd(5)+(m[3]||'').trim().padEnd(10)+m[4].trim();
}
const output={};
for(const [file,orig] of Object.entries(original)){
 let s=orig.replace(/\r\n/g,'\n');const hi=headerInfo(s);
 if(!groups[hi.name]){orders[hi.name]=s.slice(hi.start+1,hi.end).replace(/\/\/[^\n]*/g,'').split(',').map(x=>x.trim());output[file]=s;continue;}
 const raw=s.slice(hi.start+1,hi.end).replace(/\/\/[^\n]*/g,'');
 const ports=raw.split(',').map(x=>x.trim()).filter(Boolean);
 const pm=new Map(ports.map(p=>[p.match(/(\w+)\s*$/)[1],p]));
 const sets=groups[hi.name].map(g=>{const [title,ns]=g.split(':');return {title,names:ns.split(' ')};});
 const names=sets.flatMap(g=>g.names);
 if(names.length!==pm.size||names.some(n=>!pm.has(n)))throw Error('Port coverage '+file);
 orders[hi.name]=names;
 const lines=[];
 for(const g of sets){lines.push('    // '+g.title);for(const n of g.names){lines.push(formatDecl(pm.get(n),'    ')+(n===names.at(-1)?'':','));}lines.push('');}
 const end=s.indexOf(';',hi.end)+1;
 const prefix=s.slice(0,hi.start);
 let body=s.slice(end);
 const declarations=[];
 body=body.replace(/^[ \t]*(?:wire|reg|localparam)\b[^\n;]*;[^\n]*\n/gm,line=>{declarations.push(line.trim());return '';});
 const locals=declarations.filter(d=>d.startsWith('localparam'));
 const wires=declarations.filter(d=>d.startsWith('wire'));
 const regs=declarations.filter(d=>d.startsWith('reg'));
 let ds='';
 for(const [label,list] of [['Local parameters',locals],['Internal wires',wires],['Internal registers',regs]]){if(list.length)ds+='// '+label+'\n'+list.map(x=>formatDecl(x)).join('\n')+'\n\n';}
 s=prefix+'(\n'+lines.join('\n').trimEnd()+'\n);\n\n'+ds+body.replace(/^\s*\n/,'');
 moduleInfo[file]={ports:pm,declarations};
 output[file]=s;
}
// Align named connections with the corresponding module port declaration.
const types=Object.keys(orders).sort((a,b)=>b.length-a.length).join('|');
const instRe=new RegExp('^([ \\t]*)('+types+')\\s*(#\\s*\\([^;]*?\\)\\s*)?(\\w+)\\s*\\(','gm');
for(const file of files){
 let s=output[file];let matches=[...s.matchAll(instRe)];
 for(const m of matches.reverse()){
  const start=m.index+m[0].length-1;const end=matching(s,start);const text=s.slice(start+1,end);
  const cs=[...text.matchAll(/\.(\w+)\s*\(([^()]*)\)/g)].map(c=>({name:c[1],value:c[2].trim()}));
  if(!cs.length)continue;
  const leftover=text.replace(/\.(\w+)\s*\(([^()]*)\)/g,'').replace(/\/\/[^\n]*/g,'').replace(/[\s,]/g,'');
  if(leftover)throw Error('Unsupported connections '+file+' '+m[4]);
  const order=orders[m[2]];cs.sort((a,b)=>{const ai=order.indexOf(a.name),bi=order.indexOf(b.name);return (ai<0?999:ai)-(bi<0?999:bi);});
  const width=Math.max(...cs.map(c=>c.name.length));
  const block=cs.map((c,i)=>m[1]+'    .'+c.name.padEnd(width)+' ('+c.value+')'+(i===cs.length-1?'':',')).join('\n');
  s=s.slice(0,start+1)+'\n'+block+'\n'+m[1]+s.slice(end);
 }
 // Normalize tabs/blank lines in the custom RTL, without changing expressions.
 if(moduleInfo[file])s=s.split('\n').map(l=>l.replace(/^\t+/,t=>'    '.repeat(t.length)).replace(/[ \t]+$/,'')).join('\n').replace(/\n{3,}/g,'\n\n');
 output[file]=s.trimEnd()+'\n';
}
// Compare tokens after removing only reordered declarations and named connections.
function canonical(src){
 let s=src.replace(/\/\/[^\n]*|\/\*[\s\S]*?\*\//g,'');
 const hi=headerInfo(s);
 if(groups[hi.name]){
  const p=s.slice(hi.start+1,hi.end).split(',').map(norm).sort();
  s=s.slice(0,hi.start)+'('+p.join(',')+')'+s.slice(hi.end+1);
 }
 const ds=[];s=s.replace(/^[ \t]*(?:wire|reg|localparam)\b[^\n;]*;/gm,d=>{ds.push(norm(d));return '';});
 s=s.replace(instRe,(all)=>all); // Reset the global matcher before collecting instances.
 const ms=[...s.matchAll(instRe)];
 for(const m of ms.reverse()){
  const start=m.index+m[0].length-1,end=matching(s,start),t=s.slice(start+1,end);
  const cs=[...t.matchAll(/\.(\w+)\s*\(([^()]*)\)/g)].map(c=>'.'+c[1]+'('+norm(c[2])+')').sort();
  if(cs.length)s=s.slice(0,start+1)+cs.join(',')+s.slice(end);
 }
 return norm(s)+'|DECLS|'+ds.sort().join('|');
}
for(const file of files){
 if(canonical(original[file])!==canonical(output[file]))throw Error('Semantic token mismatch '+file);
 if(fs.readFileSync(path.join(root,file),'latin1')!==original[file])throw Error('Concurrent edit '+file);
}
for(const file of files)if(original[file].replace(/\r\n/g,'\n')!==output[file]){fs.writeFileSync(path.join(root,file),output[file].replace(/\n/g,'\r\n'),'latin1');console.log('Organized '+file);}
console.log('Verified port types, connection maps, declarations and executable tokens for '+files.length+' RTL files.');
