import json

def b(v):
    """per-cycle 0/1 list -> wave string"""
    s, prev = "", None
    for x in v:
        c = str(x)
        s += "." if c == prev else c
        prev = c
    return s

def d(v, color="="):
    """per-cycle label list (None = x) -> (wave, data). tuple (label,color) allowed"""
    s, data, prev = "", [], object()
    for x in v:
        if isinstance(x, tuple):
            lab, col = x
        else:
            lab, col = x, color
        if x == prev:
            s += "."
        elif lab is None:
            s += "x"
        else:
            s += col
            data.append(str(lab))
        prev = x
    return {"wave": s, "data": data}

def sig(name, v=None, wave=None, data=None):
    o = {"name": name}
    if wave is not None:
        o["wave"] = wave
        if data: o["data"] = data
    return o

def pulse(n, idxs):
    return b([1 if i in idxs else 0 for i in range(n)])

def save(fn, signal, title, foot=None, hscale=1):
    j = {"signal": signal, "head": {"text": title}, "config": {"hscale": hscale}}
    if foot: j["foot"] = {"text": foot}
    open(fn, "w").write(json.dumps(j, ensure_ascii=False))

# ---------------- 1. one bit zoom ----------------
N = 18
cnt = [i % 8 for i in range(N)]
scl = [1 if c < 4 else 0 for c in cnt]
upd = [i for i in range(N) if cnt[i] in (3, 7)]
sh = [i for i in range(N) if cnt[i] == 5]
smp = [i for i in range(N) if cnt[i] == 1]
sda = ["D7" if i < 6 else "D6" if i < 14 else "D5" for i in range(N)]
cbit = [0 if i < 4 else 1 if i < 12 else 2 for i in range(N)]
x = d(cnt); s1 = d(sda, "3"); cb = d(cbit)
save("w1.json", [
    {"name": "clk", "wave": "p" + "." * (N - 1)},
    {"name": "cnt_clk", **x},
    {"name": "scl", "wave": b(scl)},
    {"name": "scl_update", "wave": pulse(N, upd)},
    {"name": "shift", "wave": pulse(N, sh)},
    {"name": "sampling", "wave": pulse(N, smp)},
    {"name": "sda", **s1},
    {"name": "cnt_bit", **cb},
], "① 1비트 확대 (반주기 4clk로 축소, 실제 cnt 0~99)",
 "SCL↓(cnt3)에서 cnt_bit+1 → low 중간(cnt5) shift로 SDA 변경 → high 중간(cnt1) sampling")

# ---------------- 2a. IDLE -> START -> dev ----------------
N = 18
st = ["IDLE"] * 2 + ["START"] * 4 + ["DEV"] * 12
cc = [None] * 2 + [i % 8 for i in range(16)]
scl = [1] * 6 + [0] * 4 + [1] * 4 + [0] * 4
start = pulse(N, [1])
smp = [3, 11]
upd = [5, 9, 13, 17]
sh = [7, 15]
sda = [1] * 4 + [0] * 4 + ["A6"] * 8 + ["A5"] * 2
sda_d = d([("1" if v == 1 else "0" if v == 0 else v, "3") if v not in (0, 1) else v for v in sda])
# build sda wave manually: levels then data
sda_wave = "1...0..." + "3......." + "3."
sel = ["fsm"] * 8 + ["p2s"] * 10
cbit = [None] * 2 + [0] * 12 + [1] * 4
save("w2a.json", [
    {"name": "clk", "wave": "p" + "." * (N - 1)},
    {"name": "start", "wave": start},
    {"name": "state", **d(st)},
    {"name": "cnt_clk", **d(cc)},
    {"name": "scl", "wave": b(scl)},
    {"name": "sampling", "wave": pulse(N, smp)},
    {"name": "scl_update", "wave": pulse(N, upd)},
    {"name": "shift", "wave": pulse(N, sh)},
    {"name": "sel_sda", **d(sel)},
    {"name": "sda", "wave": sda_wave, "data": ["A6 (MSB)", "A5"]},
    {"name": "cnt_bit", **d(cbit)},
], "②-a START (IDLE → START → DEV)",
 "SCL high 중간에 SDA 1→0 = START / SCL↓에서 DEV 진입 / 첫 shift에서 P2S load·sel_sda 전환")

# ---------------- 2b. RESTART ----------------
N = 18
st = ["START_REG"] * 4 + ["START (Sr)"] * 8 + ["DEV"] * 6
cc = [i % 8 for i in range(N)]
scl = [1 if c < 4 else 0 for c in cc]
smp = [1, 9, 17]
upd = [3, 7, 11, 15]
sh = [5, 13]
sda_wave = "0.....1...0...3..."
sel = ["release"] * 6 + ["fsm"] * 8 + ["p2s"] * 4
cbit = [8] * 4 + [None] * 8 + [0] * 6
cby = [1] * 4 + [2] * 14
save("w2b.json", [
    {"name": "clk", "wave": "p" + "." * (N - 1)},
    {"name": "state", **d(st)},
    {"name": "cnt_clk", **d(cc)},
    {"name": "scl", "wave": b(scl)},
    {"name": "scl_update", "wave": pulse(N, upd)},
    {"name": "shift", "wave": pulse(N, sh)},
    {"name": "sampling", "wave": pulse(N, smp)},
    {"name": "sel_sda", **d(sel)},
    {"name": "sda", "wave": sda_wave, "data": ["A6"]},
    {"name": "cnt_bit", **d(cbit)},
    {"name": "cnt_byte", **d(cby)},
], "②-b RESTART (START_REG의 ACK 비트 → Sr → DEV(R))",
 "low 중간 SDA=1(release) → SCL↑ → high 중간 SDA 1→0 → SCL↓(scl_oe==0인 update)에서 DEV / cnt_byte는 유지")

# ---------------- 2c. STOP ----------------
N = 16
st = ["WRITE"] * 4 + ["STOP"] * 6 + ["IDLE"] * 6
cc = [i % 8 for i in range(10)] + [None] * 6
scl = [1, 1, 1, 1, 0, 0, 0, 0, 1, 1] + [1] * 6
smp = [1, 9]
upd = [3, 7]
sh = [5]
sda_wave = "0.........1....."
done = pulse(N, [9])
sen = [1] * 10 + [0] * 6
save("w2c.json", [
    {"name": "clk", "wave": "p" + "." * (N - 1)},
    {"name": "state", **d(st)},
    {"name": "cnt_clk", **d(cc)},
    {"name": "scl", "wave": b(scl)},
    {"name": "scl_update", "wave": pulse(N, upd)},
    {"name": "shift", "wave": pulse(N, sh)},
    {"name": "sampling", "wave": pulse(N, smp)},
    {"name": "sda", "wave": sda_wave},
    {"name": "done", "wave": done},
    {"name": "start_en", "wave": b(sen)},
], "②-c STOP (마지막 ACK 비트 → STOP → IDLE)",
 "ACK 샘플 후 SCL↓에서 STOP → low 중간 SDA=0 구동 → SCL↑ → high 중간 SDA 0→1 = STOP, done 1clk")

# ---------------- 3. packet overview ----------------
def packet(seq):
    """seq: list of (state, cnt_byte, scl_wave_chunk, sda_chunks[(wave,label)])"""
    pass

# Write length=1
# cells: IDLE, S, dev 8 + A, reg 8 + A, data 8 + A, P, IDLE
scl_w = "1" + "1" + "n" * 27 + "n" + "1"
scl_w = "1" "." + "n" * 27 + "n" + "h"
sda_w = "1" + "0" + "3......." + "5" + "3......." + "5" + "3......." + "5" + "0" + "1"
sda_w_data = ["dev_addr, W", "A", "ctrl2 (=0x01)", "A", "data[639:632]", "A"]
state_w = "x" + "=" + "=" + "." * 8 + "=" + "." * 8 + "=" + "." * 8 + "=" + "="
state_w_data = ["START", "DEV", "START_REG", "WRITE", "STOP", "IDLE"]
state_w = "=" + state_w[1:]
state_w_data = ["IDLE"] + state_w_data
cby_w = "x" + "=" + "." * 9 + "=" + "." * 8 + "=" + "." * 8 + "=" + "x"
cby_w_data = ["0", "1", "2", "3"]
seld_w = "x" + "x" + "=" + "." * 8 + "=" + "." * 8 + "=" + "." * 8 + "x" + "x"
seld_w_data = ["0", "1", "2"]
done_w = "0" + "." * 28 + "10"
start_w = "10" + "." * 29
L = len(scl_w)
assert all(len(s) == L for s in [sda_w, state_w, cby_w, seld_w, done_w, start_w]), [len(s) for s in [scl_w, sda_w, state_w, cby_w, seld_w, done_w, start_w]]
save("w3a.json", [
    {"name": "start", "wave": start_w},
    {"name": "state", "wave": state_w, "data": state_w_data},
    {"name": "scl", "wave": scl_w},
    {"name": "sda", "wave": sda_w, "data": sda_w_data},
    {"name": "cnt_byte", "wave": cby_w, "data": cby_w_data},
    {"name": "sel_data", "wave": seld_w, "data": seld_w_data},
    {"name": "done", "wave": done_w},
], "③-a 패킷 전체: Write, length=1, ctrl2=1  (1칸 = SCL 1주기)",
 "노랑 = 마스터 구동 / 파랑 = 슬레이브 ACK / WRITE 탈출: cnt_byte-2 == length (3-2=1)", hscale=1)

# Read length=2
cells = []  # (state, cnt_byte, scl, sda_wave, sda_label, rw)
cells.append(("IDLE", None, "h", "1", None, None))
cells.append(("START", 0, "h", "0", None, 0))
cells += [("DEV", 0, "n", "3" if i == 0 else ".", "dev_addr, W" if i == 0 else None, 0) for i in range(8)]
cells.append(("DEV", 0, "n", "5", "A", 0))
cells += [("START_REG", 1, "n", "3" if i == 0 else ".", "ctrl2" if i == 0 else None, 0) for i in range(8)]
cells.append(("START_REG", 1, "n", "5", "A", 0))
cells.append(("START", 2, "n", "4", "Sr", 1))
cells += [("DEV", 2, "n", "3" if i == 0 else ".", "dev_addr, R" if i == 0 else None, 1) for i in range(8)]
cells.append(("DEV", 2, "n", "5", "A", 1))
cells += [("READ", 3, "n", "5" if i == 0 else ".", "RD0 → rf[1]" if i == 0 else None, 0) for i in range(8)]
cells.append(("READ", 3, "n", "3", "ACK", 0))
cells += [("READ", 4, "n", "5" if i == 0 else ".", "RD1 → rf[2]" if i == 0 else None, 0) for i in range(8)]
cells.append(("READ", 4, "n", "3", "NACK", 0))
cells.append(("STOP", 5, "n", "0", None, 0))
cells.append(("IDLE", None, "h", "1", None, None))

def col(vals):
    w, data, prev = "", [], object()
    for v in vals:
        if v == prev: w += "."
        elif v is None: w += "x"
        else: w += "="; data.append(str(v))
        prev = v
    return w, data

stw, std = col([c[0] for c in cells])
# make consecutive identical states separated if they are different segments: handle START twice / DEV twice are non-adjacent so fine
cbw, cbd = col([c[1] for c in cells])
rww = "".join(["x" if c[5] is None else str(c[5]) for c in cells])
rww = b([c[5] if c[5] is not None else "x" for c in cells])
sclw = "".join(c[2] for c in cells)
sdaw = "".join(c[3] for c in cells)
sdad = [c[4] for c in cells if c[4]]
startw = "10" + "." * (len(cells) - 2)
donew = "0" + "." * (len(cells) - 3) + "10"
save("w3b.json", [
    {"name": "start", "wave": startw},
    {"name": "state", "wave": stw, "data": std},
    {"name": "scl", "wave": sclw},
    {"name": "sda", "wave": sdaw, "data": sdad},
    {"name": "cnt_byte", "wave": cbw, "data": cbd},
    {"name": "rw", "wave": rww},
    {"name": "done", "wave": donew},
], "③-b 패킷 전체: Read, length=2, ctrl2=1  (1칸 = SCL 1주기)",
 "노랑 = 마스터 / 파랑 = 슬레이브 / 주황 = Sr. dev→READ: cnt_byte==3, NACK: cnt_byte==length+2(=4), STOP: cnt_byte-3==length", hscale=1)

# ---------------- 4. rf write ----------------
# segment: last bit high + low (8 clk), gap, next byte same
def seg(wd, a_now, a_next):
    cc = [0, 1, 2, 3, 4, 5, 6, 7]
    scl = [1, 1, 1, 1, 0, 0, 0, 0]
    cbit = [7, 7, 7, 7, 8, 8, 8, 8]
    smp = [0, 1, 0, 0, 0, 0, 0, 0]
    upd = [0, 0, 0, 1, 0, 0, 0, 1]
    wdat = ["shift…", "shift…", wd, wd, wd, wd, wd, wd]
    we = [0, 0, 0, 0, 1, 0, 0, 0]
    addr = [a_now] * 5 + [a_next] * 3
    return cc, scl, cbit, smp, upd, wdat, we, addr

A = seg("WD0", "A0 (=ctrl2)", "A1")
B = seg("WD1", "A1", "A2")
def join(i, gapv="|"):
    return A[i] + B[i]
names = ["cnt_clk", "scl", "cnt_bit", "sampling", "scl_update", "wdata[7:0]", "we (= addr_inc)", "addr[6:0]"]
sigs = [{"name": "clk", "wave": "p......." + "|p......."}]
for k, nm in enumerate(names):
    va, vb = A[k], B[k]
    if nm in ("scl", "sampling", "scl_update", "we (= addr_inc)"):
        wa, wb = b(va), b(vb)
        if str(va[-1]) == str(vb[0]): wb = "." + wb[1:]
        sigs.append({"name": nm, "wave": wa + "|" + wb})
    else:
        ja, jb = d(va), d(vb)
        sigs.append({"name": nm, "wave": ja["wave"] + "|" + jb["wave"], "data": ja["data"] + jb["data"]})
save("w4.json", sigs, "④ Register file 쓰기 (READ 바이트의 마지막 비트 → ACK 비트)",
     "8번째 비트 sampling 후 wdata 완성 → SCL↓(cnt_bit 7→8)에서 we 1clk → addr +1 (ctrl2부터 증가)")
print("ok")
