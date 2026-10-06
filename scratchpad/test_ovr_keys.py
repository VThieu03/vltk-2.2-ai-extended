import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "tools"))
from kskill_data import load

data = load()
all_skills = {s['kv']: s for cl, sks in data.items() for s in sks}

new_ovr = {
    # NDD (Ngu Doc Dao)
    'A075': {'kind': 5, 'hits': 1},
    'A077': {'kind': 6, 'dur': 15},
    'A07A': {'kind': 5, 'hits': 2},
    'A07F': {'kind': 2, 'hits': 2},
    'A07G': {'kind': 4, 'hits': 3},
    'A07N': {'kind': 5, 'hits': 2},
    # NDC (Ngu Doc Chuong)
    'A06J': {'kind': 2, 'hits': 2},
    'A06S': {'kind': 4, 'hits': 3},
    'A06T': {'kind': 5, 'hits': 2},
    'A06U': {'kind': 4, 'hits': 5},
    # DMPT (Duong Mon Phi Tieu)
    'A0XZ': {'kind': 5, 'hits': 3},
    'A0Y1': {'kind': 4, 'hits': 9},
    'A0Y2': {'kind': 4, 'hits': 3},
    'A0Y9': {'kind': 5, 'hits': 6},
    # DMTT (Duong Mon Tu Tien)
    'A07R': {'kind': 4, 'hits': 4},
    'A07T': {'kind': 3},
    'A082': {'kind': 4, 'hits': 8},
    'A083': {'kind': 5, 'hits': 4},
    'A08B': {'kind': 4, 'hits': 6},
    # DMPD (Duong Mon Phi Dao)
    'A08H': {'kind': 5, 'hits': 2},
    'A08J': {'kind': 4, 'hits': 3},
    'A08K': {'kind': 5, 'hits': 3},
    'A08S': {'kind': 3},
    # TND (Thien Nhan Dao)
    'A0F4': {'kind': 2, 'hits': 2},
    'A0F5': {'kind': 4, 'hits': 4},
    'A0F6': {'kind': 2, 'hits': 2},
    'A0FJ': {'kind': 3},
    'A0FK': {'kind': 4, 'hits': 5},
    'A0FP': {'kind': 5, 'hits': 5},
    # TNK (Thien Nhan Kich)
    'A0G0': {'kind': 2, 'hits': 2},
    'A0G1': {'kind': 2, 'hits': 3},
    'A0G2': {'kind': 5, 'hits': 3},
    'A0G5': {'kind': 4, 'hits': 10},
    'A0G8': {'kind': 3},
    # NMC (Nga My Chuong)
    'A0AR': {'kind': 5, 'hits': 2},
    'A0B1': {'kind': 5, 'hits': 3},
    'A0BA': {'kind': 4, 'hits': 6},
    'A0B7': {'kind': 6, 'dur': 300, 'stats': [(6, 15, 2)]},
    # NMK (Nga My Kiem)
    'A0A5': {'kind': 5, 'hits': 2},
    'A0AN': {'kind': 5, 'hits': 3},
    'A0AO': {'kind': 5, 'hits': 5},
    'A0A6': {'kind': 7, 'dur': 20},
    'A0A7': {'kind': 7, 'dur': 20},
    # TLD (Thieu Lam Dao)
    'A03H': {'kind': 2, 'hits': 2},
    'A03R': {'kind': 2, 'hits': 2},
    'A043': {'kind': 4, 'hits': 3},
    'A040': {'kind': 4, 'hits': 6},
    'A03N': {'kind': 6, 'dur': 300, 'stats': [(11, 15, 2)]},
    'A03S': {'kind': 6, 'dur': 300, 'stats': [(5, 20, 2)]},
    # TLB (Thieu Lam Bong)
    'A047': {'kind': 2, 'hits': 2},
    'A04C': {'kind': 4, 'hits': 3},
    'A04O': {'kind': 4, 'hits': 2},
    'A04D': {'kind': 4, 'hits': 4},
    'A049': {'kind': 6, 'dur': 300, 'stats': [(6, 20, 2)]},
    'A04L': {'kind': 6, 'dur': 300, 'stats': [(13, 30, 3)]},
    # CLD (Con Lon Dao)
    'A0IK': {'kind': 2, 'hits': 2},
    'A0IL': {'kind': 2, 'hits': 2},
    'A0IM': {'kind': 4, 'hits': 3},
    'A0J0': {'kind': 6, 'dur': 300, 'stats': [(5, 25, 2)]},
    'A0J1': {'kind': 3},
    # DTK (Doan Thi Khi)
    'A0D5': {'kind': 2, 'hits': 2},
    'A0D6': {'kind': 5, 'hits': 6},
    'A0D7': {'kind': 5, 'hits': 2},
    'A0D8': {'kind': 2, 'hits': 18},
    # DTC (Doan Thi Chi)
    'A0DB': {'kind': 1, 'hits': 2},
    'A0DO': {'kind': 5, 'hits': 2},
    'A0DQ': {'kind': 3},
    'A0DU': {'kind': 5, 'hits': 9},
    'A0DD': {'kind': 1, 'hits': 3},
    # CMC (Co Mo Cham)
    'A0LS': {'kind': 5, 'hits': 2},
    'A0M8': {'kind': 3},
    'A0MA': {'kind': 2, 'hits': 7},
    'A0MC': {'kind': 4, 'hits': 20},
    'A0LU': {'kind': 5, 'hits': 3},
    # CMK (Co Mo Kiem)
    'A0ML': {'kind': 5, 'hits': 2},
    'A0MM': {'kind': 2, 'hits': 2},
    'A0N2': {'kind': 2, 'hits': 3},
    'A0N6': {'kind': 3},
    'A0MN': {'kind': 5, 'hits': 3},
    # TDC (Tieu Dao Chuong)
    'A0H5': {'kind': 2, 'hits': 2},
    'A0HK': {'kind': 5, 'hits': 4},
    'A0H6': {'kind': 4, 'hits': 3},
    'A0HQ': {'kind': 4, 'hits': 15},
    'A0H7': {'kind': 5, 'hits': 3},
    'A0XG': {'kind': 3},
    # TDK (Tieu Dao Kiem)
    'A0GE': {'kind': 5, 'hits': 2},
    'A0GV': {'kind': 4, 'hits': 4},
    'A0GF': {'kind': 2, 'hits': 3},
    'A0GU': {'kind': 4, 'hits': 12},
    'A0GG': {'kind': 5, 'hits': 4},
    # TYK (Thuy Yen Kiem)
    'A0BM': {'kind': 5, 'hits': 2},
    'A0BP': {'kind': 5, 'hits': 8},
    'A0BU': {'kind': 2, 'hits': 2},
    'A0BV': {'kind': 4, 'hits': 10},
    'A0BY': {'kind': 5, 'hits': 3},
    # CBB (Cai Bang Bong)
    'A0EK': {'kind': 5, 'hits': 2},
    'A0EL': {'kind': 5, 'hits': 3},
    'A0EM': {'kind': 4, 'hits': 6},
    'A0F0': {'kind': 4, 'hits': 12},
    'A0EX': {'kind': 6, 'dur': 300, 'stats': [(5, 20, 2)]},
}

missing = [k for k in new_ovr if k not in all_skills]
if missing:
    print("MISSING KEYS:", missing)
else:
    print(f"PASS: All {len(new_ovr)} skill IDs exist 100% in KVCT database!")
