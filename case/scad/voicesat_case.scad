// =====================================================================
//  Home Assistant voice satellite case  v3.7   (PERSONAL REMIX - do not redistribute)
//  Pi Zero 2 W + ReSpeaker 2-Mics Pi HAT v1.0 + square 3" 4R/5W driver (80x80, 60x60 holes)
//
//  Based on MakerWorld #638687 "Wyoming Satelite Homeassistant Jarvis Raspi 2W"
//  (MakerWorld Standard Digital File License: personal use only, no sharing /
//  redistribution of derivatives / commercial use).  The HAT mount pattern
//  (4 x 3.0 mm holes on 58.4 x 23.4, 52 x 5.2 header slot) is copied from the original.
//
//  v3.2 = user's real measurements:
//   - driver flange 0.5 mm, oval holes ~5x4 mm (M3 + washer), surround +1.5 mm,
//     magnet D35, displacement re-estimated (35 cm3)
//   - Pi top -> HAT underside 11 mm (stack_h); HAT front parts up to 6 mm tall
//   - micro-USB centre 13.5 mm below the HAT top edge, plug body 10 x 7 mm
//   - screw heads measured M2.5 D4 x 1, M3 D5 x 2 (clearances use max(measured, ISO 7380))
//   - NO magnets: grille = hinge-and-snap (2 rigid bottom hooks in floor grooves +
//     2 flexible snap tongues in the lid front edge, releasable 45 deg return, pry notch)
//   - fabric-ready grille frame: rounded 45deg+R3 edge, 1 mm fabric gap to the body,
//     glue channel on the back of the frame
//   - fasteners only from the FandWay ISO 7380 set; captive nuts everywhere
//  v3.3b = all HAT feature positions re-measured from ruler photos of the user's keyestudio clone.
//  v3.3 = pin relief under the HAT: through-hole pins of the JST + Grove connectors protrude from
//     the HAT back -> recess (pin_relief_depth) in the panel front under the connector band; HAT rests
//     on the rest of the panel + full-height pads round the screw holes.
//  v3.4 = v3.2 test-print feedback: NO side-slot nut traps anywhere (lid bosses: bottom-entry press-in pocket,
//     pulled in by the screw; HAT/Pi: one M2.5x16 through-bolt per corner + plain tube); nut pockets +0.2 AF;
//     clearance holes +0.2; board gap 11.5; speaker cable slot 10 x 5.5; speaker frame drop recess 2.8 deep
//     inside a 0.5 mm seat ring (+ 45 deg stiffening ring behind); plunger guide +0.3 + lead-ins; diffuser light
//     area 0.6 mm; hinge tooth +0.5; speaker cut-out teardrop now really points UP (mirror bug fixed).
//  v3.7 = right outer wall moved 3 mm outwards (W 165 -> 168): the Pi Zero's microSD card (left short edge seen from the
//         component side with the header on top = RIGHT side in the case, 180 deg mount) stuck ~3 mm out and hit the wall.
//         HAT, Pi, speaker, brace, clips, hinge hooks stay at the same absolute x; only the right wall and what hangs on it move.
//  v3.6 = access fix: the two middle lid bosses sat ON the brace, so the brace wall ran straight under their bottom-entry
//         nut pockets (no finger or tweezers could put a nut in). They now sit beside the brace on the Pi side (x 98),
//         same corbel shape as the verified wall bosses. + grille filler tooth closes the 45 deg roof triangle of the USB notch.
//  v3.5 = final: v3.4 base sizes confirmed by the quick test; board gap 11.0 (tube 8.0) for the M2.5x16 through-bolt.
//  Colours: everything black PLA Matte, diffuser white PLA Basic.
//
//  Coordinates: X = width (left->right seen from front), Y = depth (0 = front
//  face of the front panel, + towards back), Z = height (0 = bottom).
// =====================================================================

part = "assembly";
print_orient = true;

// ---------------- driver (user's square 3" stamped-steel full-range) ----------------
spk_frame_w    = 80;    // square frame side
spk_frame_t    = 0.5;   // MEASURED steel flange thickness = depth of the flush recess
spk_chamfer    = 5;     // frame corner chamfer leg
spk_hole_pitch = 60;    // square hole pattern (centre-centre)
spk_hole_d     = 3.6;   // v3.4 (+0.2): M3 clearance in the baffle (driver holes are OVAL ~5 x 4 mm -> M3 washer needed)
spk_slot       = [5, 4]; // measured oval hole in the frame (drawing only)
spk_surround   = 1.5;   // MEASURED surround protrusion in front of the frame
spk_magnet_d   = 35;    // MEASURED magnet diameter
spk_magnet_h   = 16;    // ESTIMATED magnet + plates height (rear end at spk_depth)
spk_cutout_d   = 71;    // baffle cut-out (70-72)
spk_depth      = 40;    // flange front -> magnet back
spk_disp_cm3   = 35;    // ESTIMATE: magnet 15.4 + cone front air behind the panel ~17 + basket/spider ~3
spk_washer     = 0.5;   // M3 washer under each speaker screw head (oval holes are as wide as the head)
spk_off_x      = 3.5;   // extra shift right (->unequal left/top edge distances)
spk_off_z      = -4;    // shift down from vertical centre of the inner box
// v3.4 (user test): the stamped frame is flat (0.5 mm seat) only round the screw holes; from ~0.5 mm inside the
// hole edge towards the cone it drops -> 2.8 mm deep recess inside a circle through those points.
spk_drop_depth = 2.8;
spk_drop_r     = spk_hole_pitch/sqrt(2) - spk_slot[0]/2 - 0.5;   // 42.43 - 2.5 - 0.5 = 39.43
spk_drop_top   = spk_frame_w/2 + 0.3;   // teardrop roof truncated inside the 0.5 mm seat recess (hidden by the frame)
spk_ring_ro    = 44;    // stiffening ring behind the panel: outer radius at the panel, 45 deg both sides
spk_ring_h     = 2.5;   // ring depth behind the panel

// ---------------- box ----------------
W_in      = 163;   // inner width (v3.7: +3 on the right for the Pi's microSD card)
H_in      = 92;    // inner height
D_in_bot  = 66;    // inner depth (behind baffle) at the floor
D_in_top  = 54;    // inner depth at the top -> back wall tilted ~7.4 deg
wall      = 2.5;   // like the original
baffle_t  = 4.0;   // speaker baffle (stiffer than the original 2.5)
lid_t     = 4.0;
recess    = 9;     // front recess (lip) depth in the body
spk_clear = 4;     // min frame-to-wall clearance
col       = 9;     // lid screw boss size (room for an M3 nut slot with 1.6 mm walls)
corbel_h  = 18;    // boss height below the rim (45 deg underside)
corbel_zclip = 16.5; // bosses never reach lower than H_tub-16.5 (clears Pi + spacers)
tongue_h  = 3;
rib_t = 2; rib_h = 4;
brace_t   = 2;     // open "window" brace between speaker and electronics regions
feet      = true;

// ---------------- port (OFF by default; only for a driver with EBP > ~90) ----------------
port_enable = false;
port_d   = 22;     // inner diameter
port_len = 60;     // physical length (tube + back wall)
port_flare = 3;    // flare radius both ends
port_pos = [145, 22]; // x, z on the back wall (bottom right, clear of driver, ribs and Pi)

// ---------------- grille (front cap, snap-fit, fabric-ready) ----------------
fab_gap    = 1.0;  // gap between frame back and the body lip (room for 0.5-1 mm speaker cloth)
cap_d      = 4.5;  // frame depth
grille_t   = 1.6;  // perforated plate thickness (< hole size)
frame_w    = 5.0;  // solid frame ring width
cap_rc     = 3;    // corner radius seen from the front
hex_af     = 6.0;  // hole across flats
hex_web    = 1.2;  // web  -> (6/7.2)^2 = 69 % open in the perforated field
ch_off = 1.0; ch_w = 1.6; ch_d = 1.2;   // fabric glue channel on the back of the frame
// snap latches (lid tongues) and hinge hooks (floor grooves)
latch_x    = [40, 125];   // tongue centres (top)
tongue_L   = 22;  tongue_t = 2.0;  tongue_y = [-8.8, -1.4];
bump_h     = 1.3;  bump_w = 4;  bump_y = [-5.6, -4.6];   // below lid underside; flat bottom y-range
tab_t      = 1.6;  tab_gap = 0.4;  tab_w = 16;  tab_tip = -1.5;
hook_x     = [40, 125];   // bottom hooks
hook_w     = 20;  hook_t = 1.6;  hook_tip = -3.5;
groove_y   = [-7.2, -4.1]; groove_d = 1.7;   /* v3.4: was [-7.2,-4.4] x 1.2 -> deeper tooth still swings in; 0.8 floor left */               // floor groove, depth into the 2.5 mm floor
tooth      = [-6.8, -4.8]; tooth_d = 1.4;   // v3.4: +0.5 engagement (was 0.9)                 // tooth y-range and depth below floor top

// ---------------- electronics ----------------
pcb_w = 65; pcb_h = 30; pcb_t = 1.6;
stack_h    = 11.0; // v3.5 FINAL: board gap Pi top surface -> HAT underside (header fully seated; 11.5 in v3.4)
tube_od = 6.0; tube_id = 3.0;      // v3.4 plain tube spacer, no nut, no slot (M2.5 through-bolt)
tube_loc_d = 6.4; tube_loc_depth = 1.0;   // round locating recess in the panel back face for the tube end
hat_hole_d = 3.2;                                    // v3.4: 3.0 gripped the M2.5 (horizontal hole, upright print)
hat_side_gap = 4.0;   // HAT right edge -> inner wall (v3.7: 1.0 + 3; micro-USB reachable through the notch, now a 6.5 mm tunnel)
hat_top_gap  = 18;    // HAT top edge -> top of tub (room for cable hole + lid nut bosses)
btn_h = 5.5; btn_stem_d = 4.0;   // tact switch height above the board (user: tallest parts 5-6 mm)
// v3.3 pin relief: only the white JST + Grove connectors have pins through the board (user, measured TBD <= 2.0 mm)
pin_relief_depth = 2.5;            // recess depth incl. margin (panel 4 mm -> 1.5 mm remains)
// MEASURED by the user (board 65 x 30, measured from the micro-USB end = right end in this model):
// one pin row 7 mm from the USB end, 33 mm long, 24 mm to the far edge (7+33+24 = 64 -> 1 mm rounding),
// 6..9 mm below the top edge, pins <= ~2 mm.  x = 25..58 (from the USB end) or 24..57 (from the far end) -> union 24..58.
pin_row          = [24, 58, 6, 9];   // board coords [x0, x1, y0, y1] (x from the left/far end, y from the top edge)
pin_margin       = 1.5;
pin_relief_zone  = [pin_row[0]-pin_margin, pin_row[1]+pin_margin, pin_row[2]-pin_margin, pin_row[3]+pin_margin];  // = [22.5, 59.5, 4.5, 10.5]
usb_tab_relief   = [58.5, 65.5, 8.0, 18.5];  // back-side solder blobs of the micro-USB shell tabs (photo X 1.9..4.9, Y 13..20.5) + 1.5 mm; insurance
pad_wall         = 0.8;              // pad = (v3.3 nut-pocket hex, AF 5.25) offset by this wall: full-height bearing pad round each HAT screw
pad_hex_d        = (5.0+0.25)/cos(30);   // kept from v3.3 so the pads/relief geometry is unchanged
function pocket_rot(q) = 30;   // all M2.5 pockets vertex-up (v3.3b: photo shows the real pins end >= 2 mm from the top-right pad, flat-up variant reverted)
hat_part_h = 6.0;  // tallest HAT front components (button, Grove, jack, JST)
// board coords [x from left, y from top edge], component side, header at the bottom
hat_holes = [[3.3,3.3],[61.7,3.3],[3.3,26.7],[61.7,26.7]];   // 58.4 x 23.4 like the original
hdr_c = [32.5, 26.4]; hdr_len = 52; hdr_w = 5.2;              // = original slot
// v3.3b: positions re-measured from the user's ruler photos of THEIR board (keyestudio "ReSpeak 2-Mic Pi HAT v1.0").
// The board is mounted rotated 180 deg vs. the photo (header at the bottom, micro-USB on the right, white connectors
// at the top): model board coords x = 65 - X_photo, y = 30 - Y_photo  (X from the left, Y from the header edge in the photo).
hat_mics  = [[2.8,21.1],[62.6,21.1]];                 // photo: RIGHT mic (X 62.2, Y 8.9), LEFT mic (X 2.4, Y 8.9)
hat_leds  = [[31.3,18.5],[33.7,18.5],[36.1,18.5]];    // photo: RGB LEDs X 28.9 / 31.3 / 33.7, Y 11.5
hat_btn   = [49.1,16.4];                              // photo: BUTTON X 15.9, Y 13.6
hat_usb_y = 12.8;  usb_protrude = 2.0;                // photo: micro-USB centre Y 17.2 (7.5 mm tall), sticks out 2 mm past the board edge
hat_conn  = [["I2C", 45.6, 60.2], ["GP12", 32.0, 45.2], ["SPEAKER", 21.9, 31.1]];   // white housings: model x ranges
conn_y    = [-2.4, 7.3];                              // housings overhang the (model) top edge by 2.4 mm
hat_jack  = [4.8, 12.0, -3.5, 9.8];                   // HEADSET jack x0,x1,y0,y1 (overhangs the top edge 3.5 mm)
hat_jst_x = (21.9+31.1)/2;                            // SPEAKER connector centre -> speaker cable hole above it
usb_plug = [10, 7]; usb_margin = 1.0; usb_rec_h = 2.8;   // plug body W x H, receptacle height
cable_slot = [10, 5.5];   // v3.4: speaker-cable pass-through (stadium) for the 8 x 4 JST plug; seal with putty
rear_usbc = false; // original-style 5.4 x 14.2 rear hole (seal around the socket!)
elec_disp_cm3 = 15; // ESTIMATE: Pi Zero 2 W + header + spacers inside the box

// ---------------- fasteners (user's FandWay ISO 7380 Torx set ONLY) ----------------
// head sizes: measured M2.5 D4 x 1, M3 D5 x 2; ISO 7380 M3 D5.7 x 1.65 -> clearances use the max.
// ISO 4032 nuts: M3 5.5 AF x 2.4, M2.5 5.0 AF x 2.0.  ISO 7089 washers 0.5 mm.
nut_clear = 0.45;   // v3.4: +0.2 across flats (0.25 needed a lot of force)
m3_af = 5.5;  m3_nut_h = 2.4;  m3_dk = 5.7;  m3_k = 2.0; m3_clear = 3.6; m3_pitch = 0.5;
m2_af = 4.0;  m2_nut_h = 1.6;  m2_dk = 3.5;  m2_k = 1.3;  m2_clear = 2.6; m2_pitch = 0.4;
m25_af = 5.0; m25_nut_h = 2.0; m25_dk = 4.7; m25_k = 1.5; m25_clear = 3.2; m25_pitch = 0.45;
spk_screw_l = 12;   spk_nut_seat = 6.0;   // speaker: M3x12 + washer, nut bears at y=6.0 (2 mm boss)
lid_screw_l = 12;   lid_cb_d = 6.2;  lid_cb_h = 2.2;   // lid: M3x12, counterbore for the button head
lid_nut_top = 4.5;                        // nut bearing face this far below the rim
gasket_c = 1.0;                           // compressed foam-tape thickness used for the calc
hat_screw_l = 16;   // v3.4: ONE M2.5x16 per corner: HAT front -> HAT -> panel -> tube -> Pi -> M2.5 nut on the Pi back
fb_screw_l = 6;  fb_cb_h = 1.0;  fb_y = -5.5;   // FALLBACK grille fixing: M2x6 through each side wall into a captive M2 nut in the side tab
fb_boss_t = 3.4;

$fn = 48;
eps = 0.01;

// ---------------- derived ----------------
W      = W_in + 2*wall;
H_tub  = wall + H_in;          // body height (open top)
H_tot  = H_tub + lid_t;
yb_bot = baffle_t + D_in_bot + wall;   // outer back at z=0
yb_top = baffle_t + D_in_top + wall;   // outer back at z=H_tub
slope  = (yb_bot - yb_top) / H_tub;
function back_out(z) = yb_bot - slope*z;
function back_in(z)  = back_out(z) - wall*sqrt(1+slope*slope);

spk_cx = wall + spk_clear + spk_frame_w/2 + spk_off_x;
spk_cz = wall + H_in/2 + spk_off_z;
brace_x = spk_cx + spk_frame_w/2 + 1.5 + brace_t/2;
board_r = W - wall - hat_side_gap;
board_l = board_r - pcb_w;
board_top = H_tub - hat_top_gap;
hat_front_y = -pcb_t;
pi_front_y  = stack_h;
tube_len    = stack_h - (baffle_t - tube_loc_depth);   // tube sits 1 mm deep in the locating recess
function bp(p) = [board_l + p[0], board_top - p[1]];

spk_holes = [for (sx=[-1,1], sz=[-1,1]) [spk_cx+sx*spk_hole_pitch/2, spk_cz+sz*spk_hole_pitch/2]];
usb_z  = board_top - hat_usb_y;
cable_pos = [board_l + hat_jst_x, board_top + 9.5];   // above the SPEAKER plug (housing top edge at +2.4, plug ~6 mm)
y_bk = back_in(H_tub);
mid_x = brace_x + brace_t/2 + col/2;   // v3.6: middle bosses beside the brace (Pi side), not on it
screws = [[wall+col/2, baffle_t+col/2], [W-wall-col/2, baffle_t+col/2], [mid_x, baffle_t+col/2],
          [wall+col/2, y_bk-col/2],     [W-wall-col/2, y_bk-col/2],     [mid_x, y_bk-col/2]];

assert(brace_x + brace_t/2 + 1.5 < board_l, "brace collides with the Pi/HAT - increase W_in");
assert(spk_cz - spk_frame_w/2 > wall + 1, "speaker frame hits the floor");
assert(spk_cz + spk_frame_w/2 < H_tub - 1, "speaker frame hits the lid");

gross = W_in*H_in*(D_in_bot+D_in_top)/2/1000;
echo(str("OUTER W x H x D = ", W, " x ", H_tot, " x ", yb_bot+recess+fab_gap+cap_d, " mm (incl. grille)"));
echo(str("Inner ", W_in, " x ", H_in, " x ", D_in_top, "..", D_in_bot, " mm, gross ", gross, " cm3"));
echo(str("Driver centre edge distances L/R/B/T = ", spk_cx, " / ", W-spk_cx, " / ", spk_cz, " / ", H_tot-spk_cz));
echo(str("Baffle step f3 ~ 115/W = ", round(115/(W/1000)), " Hz"));
echo(str("Grille perforated-field open area = ", round(100*pow(hex_af/(hex_af+hex_web),2)), " %"));
if (port_enable) {
  S = PI*pow(port_d/2000,2); Leff = port_len/1000 + 0.85*port_d/1000;  // end correction ~1.7 r (both ends flanged)
  V = gross*0.9e-6;   // m3
  echo(str("PORT tuning (Helmholtz, Vnet ~0.9*gross) Fb = ", round(343/(2*PI)*sqrt(S/(V*Leff))), " Hz"));
}

// ---------------- helpers ----------------
module ycyl(d, y0, y1, fn=$fn) { translate([0,y0,0]) rotate([-90,0,0]) cylinder(d=d, h=y1-y0, $fn=fn); }
module at_xz(p) { translate([p[0],0,p[1]]) children(); }
module frame2d(w, h, ch) { polygon([[-w/2+ch,-h/2],[w/2-ch,-h/2],[w/2,-h/2+ch],[w/2,h/2-ch],[w/2-ch,h/2],[-w/2+ch,h/2],[-w/2,h/2-ch],[-w/2,-h/2+ch]]); }
module yext(y0, h) { translate([0,y0,0]) rotate([-90,0,0]) linear_extrude(h) mirror([0,1]) children(); } // 2D (x,z) -> 3D, y0..y0+h
module xext(x0, w) { translate([x0,0,0]) rotate([90,0,90]) linear_extrude(w) children(); } // 2D (y,z) -> 3D
module outer2d(ytop=H_tub, yfront=-recess) { polygon([[yfront,0],[yb_bot,0],[back_out(ytop),ytop],[yfront,ytop]]); }
module inner2d(y0=baffle_t) {   // air region (side profile) incl. the baffle thickness
  intersection() {
    offset(delta=-wall) polygon([[-50,-50],[back_out(-50),-50],[back_out(H_tub+50),H_tub+50],[-50,H_tub+50]]);
    translate([y0, wall]) square([300, H_tub-wall+1]);
  }
}
// truncated "teardrop" cut-out: prints upright without support, flat top hidden by the frame
module spk_cut2d() { intersection() { union() { circle(d=spk_cutout_d, $fn=120); rotate(45) square(spk_cutout_d/2); }
                                      translate([-50,-50]) square([100, 50 + spk_frame_w/2 - 3]); } }
// teardrop (point UP in model z) truncated at zt, 2D (x,z) for yext
module drop2d(zt) { intersection() { union() { circle(r=spk_drop_r, $fn=160); rotate(45) square(spk_drop_r); }
                                      translate([-100,-100]) square([200, 100+zt]); } }
// frame-drop recess: full teardrop to the seat depth, then the truncated roof descends at 45 deg -> support-free upright
module spk_drop() {
  hull() {
    yext(-1, 1+spk_frame_t) drop2d(spk_drop_top);
    yext(spk_drop_depth-0.01, 0.01) drop2d(spk_drop_top-(spk_drop_depth-spk_frame_t));
  }
}
module spk_ring() {   // 45 deg trapezoid ring on the panel back, clipped to the inner box
  ri = (spk_cutout_d+4)/2;
  intersection() {
    at_xz([spk_cx, spk_cz]) translate([0, baffle_t-eps, 0]) rotate([-90,0,0]) difference() {
      cylinder(r1=spk_ring_ro, r2=spk_ring_ro-spk_ring_h, h=spk_ring_h, $fn=160);
      translate([0,0,-eps]) cylinder(r1=ri, r2=ri+spk_ring_h, h=spk_ring_h+2*eps, $fn=160);
    }
    translate([wall, 0, wall]) cube([W_in, 100, H_in]);
  }
}
module corbel(x, y0, y1, side) {   // lid screw boss with 45 deg underside, clipped above the Pi
  zb = H_tub - corbel_h; bt = brace_t;
  intersection() {
    translate([0, y1, 0]) rotate([90,0,0]) linear_extrude(y1-y0) {
      if (side == 0) polygon([[x-col/2-eps, zb], [x+col/2, zb+col], [x+col/2, H_tub], [x-col/2-eps, H_tub]]);
      if (side == 1) polygon([[x+col/2+eps, zb], [x-col/2, zb+col], [x-col/2, H_tub], [x+col/2+eps, H_tub]]);
      if (side == 2) polygon([[x-bt/2, zb], [x+bt/2, zb], [x+col/2, zb+(col-bt)/2], [x+col/2, H_tub],
                              [x-col/2, H_tub], [x-col/2, zb+(col-bt)/2]]);
    }
    translate([-1, -50, H_tub-corbel_zclip]) cube([W+2, 400, corbel_zclip]);
  }
}
// v3.4: lid-boss nut = press-in hex pocket entered from BELOW (open underside of the boss); the nut is pulled up
// into it by the lid screw.  Ceiling = short bridge (~6 mm) round the screw hole; no side slot.
module nut_well(af, z0, z1, a) { rotate(a) translate([0,0,z0]) cylinder(d=(af+nut_clear)/cos(30), h=z1-z0, $fn=6); }
lid_nut_z = H_tub - lid_nut_top;          // nut top (bearing) face
slot_dirs = [0, 180, 0, 0, 180, 0];      // FL, FR, mid-front, BL, BR, mid-back (v3.6: mid bosses = same shape/orientation as the left wall bosses)

// ---------------- BODY ----------------
module ribs() {
  for (x = [spk_cx, (board_l+board_r)/2]) xext(x-rib_t/2, rib_t)
    intersection() {
      difference() { inner2d(); offset(delta=-rib_h) inner2d(); }
      translate([baffle_t+spk_depth-2, wall-1]) square([200, H_tub-wall-tongue_h-2]);
    }
}
module brace() {
  yl = back_in(H_tub) - baffle_t;
  xext(brace_x-brace_t/2, brace_t) intersection() {
    offset(delta=0.6) inner2d(baffle_t-0.6);
    difference() {
      translate([baffle_t-eps, 0]) square([200, H_tub]);
      for (i=[0,1], j=[0,1]) let(y0 = baffle_t+6 + i*(yl/2-1), z0 = wall+6 + j*(H_in/2-2), w = yl/2-11, h = H_in/2-14)
        translate([y0, z0]) polygon([[0,0],[w,0],[w,h-w/2],[w/2,h],[0,h-w/2]]);
    }
  }
}
usb_yc = hat_front_y - usb_rec_h/2;      // receptacle centre (depth)
module usb_notch() {   // plug body + margin; also relieves the panel strip between board edge and wall.
  // The roof rises at 45 deg towards the open front so the wall above prints without supports.
  y0 = -recess-1; y1 = usb_yc+usb_plug[1]/2+usb_margin;
  z0 = usb_z-usb_plug[0]/2-usb_margin; z1 = usb_z+usb_plug[0]/2+usb_margin;
  xext(board_r+0.2, W-board_r+1) polygon([[y0, z0], [y1, z0], [y1, z1], [y0, z1+(y1-y0)]]);
}
module body() {
  difference() {
    union() {
      difference() {
        xext(0, W) outer2d();
        xext(wall, W_in) inner2d();
        translate([wall, -recess-1, wall]) cube([W_in, recess+1, H_tub]);   // front recess (open front + top)
      }
      ribs();
      brace();
      for (s = [0:5]) let(sc = screws[s])
        if (s < 3) corbel(sc[0], baffle_t-eps, baffle_t+col, s==1 ? 1 : 0);
        else intersection() { corbel(sc[0], y_bk-col, yb_bot, s==4 ? 1 : 0); xext(0, W) outer2d(); }
      for (h = spk_holes) at_xz(h) ycyl(10, baffle_t-eps, baffle_t+5);
      spk_ring();   // v3.4 stiffening ring behind the thin lip of the frame-drop recess
      if (port_enable) at_xz(port_pos) ycyl(port_d+4, back_out(port_pos[1])-port_len, back_out(port_pos[1])-1);
    }
    // driver: flush frame recess (0.5 mm), cut-out with rear 45 deg chamfer
    at_xz([spk_cx, spk_cz]) {
      translate([0, -1, 0]) rotate([-90,0,0]) linear_extrude(1+spk_frame_t) offset(delta=0.3) frame2d(spk_frame_w, spk_frame_w, spk_chamfer);
      spk_drop();   // v3.4: 2.8 mm recess where the stamped frame drops
      yext(-1, baffle_t+2) spk_cut2d();
      translate([0, baffle_t-2, 0]) rotate([-90,0,0]) linear_extrude(2.01, scale=(spk_cutout_d+4)/spk_cutout_d) mirror([0,1]) spk_cut2d();
    }
    for (h = spk_holes) at_xz(h) {
      ycyl(spk_hole_d, -1, baffle_t+6);
      translate([0, spk_nut_seat, 0]) rotate([-90,30,0]) cylinder(d=(m3_af+nut_clear)/cos(30), h=10, $fn=6); // vertex up: prints upright
    }
    // v3.3 pin relief under the connector band; 45 deg roof so it prints support-free upright
    difference() {
      union() {
      translate([board_l+pin_relief_zone[0], 0, 0]) xext(0, pin_relief_zone[1]-pin_relief_zone[0])
        polygon([[-1, board_top-pin_relief_zone[3]], [pin_relief_depth, board_top-pin_relief_zone[3]],
                 [pin_relief_depth, board_top-pin_relief_zone[2]], [0, board_top-pin_relief_zone[2]+pin_relief_depth], [-1, board_top-pin_relief_zone[2]+pin_relief_depth]]);
      translate([board_l+usb_tab_relief[0], 0, 0]) xext(0, usb_tab_relief[1]-usb_tab_relief[0])
        polygon([[-1, board_top-usb_tab_relief[3]], [pin_relief_depth, board_top-usb_tab_relief[3]],
                 [pin_relief_depth, board_top-usb_tab_relief[2]], [0, board_top-usb_tab_relief[2]+pin_relief_depth], [-1, board_top-usb_tab_relief[2]+pin_relief_depth]]);
      }
      for (q = hat_holes) at_xz(bp(q)) translate([0, -2, 0]) rotate([-90, pocket_rot(q), 0])
        linear_extrude(pin_relief_depth+3) offset(r=pad_wall) circle(d=pad_hex_d, $fn=6);
    }
    // HAT mount (original pattern): header slot (UNCHANGED, user-confirmed tight fit) + 4 through holes;
    // v3.4: no nut pockets any more, round locating recess for the tube on the panel back face
    at_xz(bp(hdr_c)) translate([-hdr_len/2, -1, -hdr_w/2]) cube([hdr_len, baffle_t+2, hdr_w]);
    for (q = hat_holes) at_xz(bp(q)) {
      ycyl(hat_hole_d, -1, baffle_t+1);
      ycyl(tube_loc_d, baffle_t-tube_loc_depth, baffle_t+1);
    }
    // speaker cable hole with countersinks both sides for a putty / hot-glue plug
    at_xz(cable_pos) hull() for (sx = [-1,1]) translate([sx*(cable_slot[0]-cable_slot[1])/2, 0, 0]) {   // v3.4 slot 10 x 5.5
      ycyl(cable_slot[1], -1, baffle_t+1); }
    at_xz(cable_pos) hull() for (sx = [-1,1]) translate([sx*(cable_slot[0]-cable_slot[1])/2, 0, 0]) ycyl(cable_slot[1]+3, -eps-1, 0.5);
    at_xz(cable_pos) hull() for (sx = [-1,1]) translate([sx*(cable_slot[0]-cable_slot[1])/2, baffle_t-1.2, 0]) rotate([-90,0,0]) cylinder(d1=cable_slot[1], d2=cable_slot[1]+3, h=1.2+eps);
    usb_notch();
    // FALLBACK grille screws: M2 clearance hole through each lip side wall, counterbore outside for the head
    for (i = [0,1]) let(t = side_tabs[i]) translate([i==0 ? -1 : W-wall-1, fb_y, fb_z(t)]) rotate([0,90,0]) {
      cylinder(d=m2_clear, h=wall+2);
      translate([0,0,i==0 ? 0 : wall+1-fb_cb_h]) cylinder(d=m2_dk+0.6, h=fb_cb_h+1);
    }
    // floor grooves for the grille hinge hooks (outside the sealed volume)
    for (x = hook_x) translate([x-hook_w/2-0.5, groove_y[0], wall-groove_d]) cube([hook_w+1, groove_y[1]-groove_y[0], groove_d+1]);
    // lid screws: M3 clearance hole + bottom-entry press-in M3 nut pocket (v3.4, no side slot)
    for (i = [0:5]) let(sc = screws[i]) translate([sc[0], sc[1], 0]) {
      translate([0,0,H_tub-corbel_h-1]) cylinder(d=m3_clear, h=corbel_h+2);
      nut_well(m3_af, H_tub-corbel_zclip-1, lid_nut_z, slot_dirs[i]);
    }
    if (port_enable) at_xz(port_pos) {
      ycyl(port_d, back_out(port_pos[1])-port_len-1, back_out(port_pos[1])+5);
      translate([0, back_out(port_pos[1])-port_len-eps, 0]) rotate([-90,0,0]) cylinder(d1=port_d+2*port_flare, d2=port_d, h=port_flare);
      translate([0, back_out(port_pos[1])-port_flare+0.01, 0]) rotate([-90,0,0]) cylinder(d1=port_d, d2=port_d+2*port_flare, h=port_flare+5);
    }
    if (rear_usbc) translate([board_l+12, back_out(12)-wall-3, 10]) cube([14.2, wall+6, 5.4]);
    if (feet) for (fx=[14, W-14], fy=[6, yb_bot-14]) translate([fx, fy, -1]) cylinder(d=10.5, h=2);
  }
}

// ---------------- LID (with 2 snap tongues in the front edge) ----------------
function tongue_x0(xc) = xc - tongue_L/2;         // root end
module bump_profile() {   // (y,z) section of the latch bump, z relative to lid underside H_tub
  yl = bump_y[0] - bump_h/tan(30);   // 30 deg lead-in (front)
  yr = bump_y[1] + bump_h;           // 45 deg return (back)
  polygon([[yl, 0], [bump_y[0], -bump_h], [bump_y[1], -bump_h], [yr, 0], [yr, lid_t-tongue_t+eps], [yl, lid_t-tongue_t+eps]]);
}
module lid() {
  difference() {
    union() {
      translate([0, 0, H_tub]) xext(0, W) polygon([[-recess,0],[yb_top,0],[yb_top,lid_t],[-recess,lid_t]]);
      translate([0,0,H_tub-tongue_h]) difference() {
        translate([wall+0.25, baffle_t+0.25, 0]) cube([W_in-0.5, y_bk-baffle_t-0.5, tongue_h+eps]);
        translate([wall+1.85, baffle_t+1.85, -1]) cube([W_in-3.7, y_bk-baffle_t-3.7, tongue_h+2]);
        for (s = screws) translate([s[0]-col/2-0.4, s[1]-col/2-0.4, -1]) cube([col+0.8, col+0.8, tongue_h+2]);
        translate([brace_x-brace_t/2-0.4, 0, -1]) cube([brace_t+0.8, 300, tongue_h+2]);
      }
      for (x = [spk_cx, (board_l+board_r)/2]) translate([x-rib_t/2, baffle_t+col+1, H_tub-rib_h]) cube([rib_t, y_bk-baffle_t-2*col-2, rib_h+eps]);
    }
    for (s = screws) { translate([s[0], s[1], H_tub-1]) cylinder(d=m3_clear, h=lid_t+2); translate([s[0], s[1], H_tot-lid_cb_h]) cylinder(d=lid_cb_d, h=3); }
    // snap tongues: thin (tongue_t) top skin, free end + back slot cut through
    for (xc = latch_x) let(x0 = tongue_x0(xc)) {
      translate([x0, -recess-1, H_tub-1]) cube([tongue_L+0.8, tongue_y[1]+0.8+recess+1, lid_t-tongue_t+1]);
      translate([x0, tongue_y[1], H_tub-1]) cube([tongue_L+0.8, 0.8, lid_t+2]);
      translate([x0+tongue_L, -recess-1, H_tub-1]) cube([0.8, tongue_y[1]+0.8+recess+1, lid_t+2]);
    }
    // pry notch (screwdriver / coin) between the two tongues, pushes the grille forward
    translate([(latch_x[0]+latch_x[1])/2-6, -recess-1, H_tot-2]) cube([12, 3.5, 3]);
  }
  // latch bumps under the free ends of the tongues
  for (xc = latch_x) let(x0 = tongue_x0(xc))
    translate([x0+tongue_L-1-bump_w, 0, H_tub]) xext(0, bump_w) bump_profile();
}

// ---------------- GRILLE (fabric-ready snap-fit front frame) ----------------
led_c   = [ (bp(hat_leds[0])[0]+bp(hat_leds[2])[0])/2, bp(hat_leds[0])[1] ];
led_win = [ abs(bp(hat_leds[2])[0]-bp(hat_leds[0])[0]) + 9, 7 ];   // light aperture in the plate (covers all 3 LEDs)
diff_lip = 0.8; diff_t = 1.2; diff_clear = 0.15;   // rim (press fit, unchanged)
diff_light_t = 0.6; diff_rim = 0.95;              // v3.4: light area 0.6 mm (3 layers), 0.95 mm rim = 2 lines
seat     = [led_win[0]+2*diff_lip, led_win[1]+2*diff_lip];
shroud_w = 1.2;
y_cb = -recess - fab_gap;          // frame back face
y_pf = y_cb - cap_d;               // plate front face
y_pi = y_pf + grille_t;            // plate inner face
guide_l = 2;
guide_hole_d = btn_stem_d + 0.9;   // v3.4: was +0.6 (jammed)
guide_lead = 0.6;
shroud_end = hat_front_y - 2.0;    // 2 mm above the board (only flat SMD parts under the shroud footprint)
// edge profile (u = outward from the corner centre, v = depth from the front face): 45 deg then R3 to vertical
module edge2d(rc) {
  R = 3; vc = 4; ue = rc - R*(1-cos(45)); ve = vc - R*sin(45); u0 = ue - ve;
  polygon(concat([[0,0],[u0,0]], [for (a=[45:-5:0]) [rc - R + R*cos(a), vc - R*sin(a)]], [[rc, cap_d], [0, cap_d]]));
}
module cap_outer() {
  hull() for (x=[cap_rc, W-cap_rc], z=[cap_rc, H_tot-cap_rc])
    translate([x, y_pf, z]) rotate([-90,0,0]) rotate_extrude($fn=32) edge2d(cap_rc);
}
module hex_field(w, h) {
  px = hex_af + hex_web; py = px*sqrt(3)/2;
  for (j = [0 : ceil(h/py)+1], i = [-1 : ceil(w/px)+1])
    translate([i*px + (j%2)*px/2, j*py]) rotate(30) circle(d=hex_af/cos(30), $fn=6);
}
function tab_xc(xc) = tongue_x0(xc) + tongue_L - 1 - bump_w/2;   // bump centre
module rrect(x0, z0, w, h, r) { translate([x0+r, z0+r]) offset(r=r) square([w-2*r, h-2*r]); }
module grille() {
  bt = bp(hat_btn);
  tz = H_tub - tab_gap - tab_t;   // top tab bottom
  hz = wall + 0.2;                // bottom hook bottom
  difference() {
    union() {
      difference() {
        cap_outer();
        translate([frame_w, y_pi, frame_w]) cube([W-2*frame_w, cap_d, H_tot-2*frame_w]);
        // fabric glue channel on the back of the frame
        translate([0, y_cb-ch_d, 0]) rotate([-90,0,0]) mirror([0,1,0]) linear_extrude(ch_d+1) difference() {
          rrect(ch_off, ch_off, W-2*ch_off, H_tot-2*ch_off, max(cap_rc-ch_off, 0.5));
          rrect(ch_off+ch_w, ch_off+ch_w, W-2*(ch_off+ch_w), H_tot-2*(ch_off+ch_w), max(cap_rc-ch_off-ch_w, 0.5));
        }
        // perforation
        translate([0,y_pf-1,0]) rotate([90,0,0]) mirror([0,0,1]) linear_extrude(grille_t+2) difference() {
          intersection() { translate([frame_w+0.8, frame_w+0.8]) square([W-2*frame_w-1.6, H_tot-2*frame_w-1.6]); hex_field(W, H_tot); }
          translate(bt) circle(d=btn_stem_d+5.6);
          translate([led_c[0]-seat[0]/2-shroud_w-1, led_c[1]-seat[1]/2-shroud_w-1]) square([seat[0]+2*shroud_w+2, seat[1]+2*shroud_w+2]);
          for (xc = latch_x) translate([tab_xc(xc)-tab_w/2-1, tz-1]) square([tab_w+2, tab_t+2]);
          for (x = hook_x) translate([x-hook_w/2-1, hz-1]) square([hook_w+2, hook_t+2]);
          for (t = side_tabs) translate([t[0]-1, t[1]-1]) square([t[2]+2, t[3]+2]);
        }
      }
      // side locating tabs (rigid) inside the lip
      for (t = side_tabs) translate([t[0], y_pi-eps, t[1]]) cube([t[2], side_tab_end-y_pi, t[3]]);
      // fallback-screw bosses on the side tabs (thickened inwards, captive M2 nut)
      for (i = [0,1]) let(t = side_tabs[i]) translate([i==0 ? t[0] : t[0]+t[2]-fb_boss_t, fb_y-4, fb_z(t)-4]) cube([fb_boss_t, 8, 8]);
      // top snap tabs (under the lid, window for the tongue bump)
      for (xc = latch_x) let(c = tab_xc(xc)) difference() {
        hull() {
          translate([c-tab_w/2, y_pi-eps, tz]) cube([tab_w, tab_tip-1-y_pi, tab_t]);
          translate([c-tab_w/2, y_pi-eps, tz]) cube([tab_w, tab_tip-y_pi, tab_t-1]);   // 1 mm lead-in chamfer at the tip
        }
        translate([c-bump_w/2-1, bump_y[0]-1.95, tz-1]) cube([bump_w+2, (bump_y[1]+1.05)-(bump_y[0]-1.95), tab_t+2]);
      }
      // bottom hinge hooks with tooth (45 deg front face = support-free when printed face-down)
      for (x = hook_x) {
        translate([x-hook_w/2, y_pi-eps, hz]) cube([hook_w, hook_tip-y_pi, hook_t]);
        translate([x-hook_w/2, 0, 0]) xext(0, hook_w)
          polygon([[tooth[0], hz+eps], [tooth[1], hz+eps], [tooth[1], hz-tooth_d-0.2], [tooth[0]+tooth_d+0.2, hz-tooth_d-0.2]]);
      }
      usb_filler();   // v3.6
      // button guide tube and LED light shroud
      at_xz(bt) ycyl(btn_stem_d+3.6, y_pi-eps, y_pi+guide_l);
      at_xz(led_c) translate([-seat[0]/2-shroud_w, y_pi-eps, -seat[1]/2-shroud_w]) cube([seat[0]+2*shroud_w, shroud_end-y_pi, seat[1]+2*shroud_w]);
    }
    at_xz(bt) { ycyl(guide_hole_d, y_pf-1, y_pi+guide_l+1);   // v3.4 +0.3 (plunger itself unchanged)
      translate([0, guide_end_y-guide_lead, 0]) rotate([-90,0,0]) cylinder(d1=guide_hole_d, d2=guide_hole_d+2*guide_lead+0.02, h=guide_lead+eps);   // lead-in (plunger enters here)
      translate([0, y_pf-eps, 0]) rotate([-90,0,0]) cylinder(d1=guide_hole_d+0.8, d2=guide_hole_d, h=0.4);   // front: against elephant foot (bed side) }
    }
    at_xz(led_c) { translate([-led_win[0]/2, y_pf-1, -led_win[1]/2]) cube([led_win[0], 20, led_win[1]]);
                   translate([-seat[0]/2, y_pi, -seat[1]/2]) cube([seat[0], 20, seat[1]]); }
    for (q = hat_mics) at_xz(bp(q)) ycyl(2.5, y_pf-1, y_pi+1);
    for (i = [0,1]) let(t = side_tabs[i], xi = i==0 ? t[0] : t[0]+t[2]) translate([0, fb_y, fb_z(t)]) {
      translate([xi + (i==0 ? -1 : -fb_boss_t-1), 0, 0]) rotate([0,90,0]) cylinder(d=m2_clear, h=fb_boss_t+2);
      translate([i==0 ? xi+1.2 : xi-1.2-fb_boss_t, 0, 0]) fb_nut_pocket();   // opens to the inside, 1.2 mm tab material against the wall
    }
  }
}
side_tabs = [[wall+0.2, 30, 1.2, 30], [W-wall-1.4, 20, 1.2, 25]];   // [x, z, thickness, height]
side_tab_end = -2.5;                 // tabs reach this far back (overlap with the 9 mm lip side wall)
function fb_z(t) = t[1] + t[3]/2;
module fb_nut_pocket() { rotate([0,90,0]) rotate([0,0,30]) cylinder(d=(m2_af+nut_clear)/cos(30), h=fb_boss_t, $fn=6); }  // vertex along y (= up when printed)

// ---------------- small parts ----------------
// v3.4 tube spacer: plain round tube, z=0 in the panel's locating recess, z=tube_len on the Pi.  No nut, no slot.
module tube() { difference() { cylinder(d=tube_od, h=tube_len, $fn=48); translate([0,0,-1]) cylinder(d=tube_id, h=tube_len+2, $fn=32);
                               translate([0,0,-eps]) cylinder(d1=tube_id+0.6, d2=tube_id, h=0.3); } }
btn_top_y   = hat_front_y - btn_h;
guide_end_y = y_pi + guide_l;
plunger_puck = (btn_top_y - 0.3) - (guide_end_y + 0.2);
plunger_stem = (guide_end_y + 0.2) - y_pf + 1.5;       // 1.5 mm proud of the plate (presses through cloth)
module plunger() {
  cylinder(d=btn_stem_d+2.8, h=plunger_puck);
  translate([0,0,plunger_puck-eps]) cylinder(d=btn_stem_d, h=plunger_stem);
  translate([0,0,plunger_puck+plunger_stem-0.8]) cylinder(d1=btn_stem_d, d2=btn_stem_d-1.6, h=0.8);
}
module led_diffuser() {   // z=0 = front face (on the bed / against the plate ledge); light area pocketed from the back
  sx = seat[0]-2*diff_clear; sz = seat[1]-2*diff_clear;
  difference() { cube([sx, sz, diff_t]); translate([diff_rim, diff_rim, diff_light_t]) cube([sx-2*diff_rim, sz-2*diff_rim, diff_t]); }
}
echo(str("Plunger puck ", plunger_puck, " mm, stem ", plunger_stem, " mm; plate inner face y=", y_pi,
         "; clearance plate -> tallest HAT part = ", (hat_front_y-hat_part_h) - y_pi, " mm"));

// ---------------- dummies ----------------
module speaker_dummy() {
  at_xz([spk_cx, spk_cz]) {
    color("silver") difference() {
      rotate([-90,0,0]) linear_extrude(spk_frame_t) frame2d(spk_frame_w, spk_frame_w, spk_chamfer);
      for (sx=[-1,1], sz=[-1,1]) translate([sx*spk_hole_pitch/2, -1, sz*spk_hole_pitch/2]) rotate([-90,0,0]) linear_extrude(3) resize(spk_slot) circle(d=5);
    }
    color("#222") difference() { ycyl(spk_cutout_d-2, -spk_surround, 0); ycyl(spk_cutout_d-12, -spk_surround-1, 1); }
    color("dimgray") rotate([-90,0,0]) cylinder(d1=spk_cutout_d-6, d2=24, h=18);
    color("#444") ycyl(spk_magnet_d, spk_depth-spk_magnet_h, spk_depth);
    color("#555") ycyl(24, 18-eps, spk_depth-spk_magnet_h+eps);
  }
}
module hat_dummy() {
  color("green") translate([board_l, hat_front_y, board_top-pcb_h]) cube([pcb_w, pcb_t, pcb_h]);
  color("darkgreen") translate([board_l, pi_front_y, board_top-pcb_h]) cube([pcb_w, pcb_t, pcb_h]);
  color("black") at_xz(bp(hdr_c)) translate([-25.4, 0, -2.54]) cube([50.8, pi_front_y, 5.08]);
  color("white") at_xz(bp(hat_btn)) translate([-3, btn_top_y, -3]) cube([6, btn_h, 6]);
  // tall front parts (from the board photo, heights per user: up to 6 mm)
  color("ivory") for (c = hat_conn) translate([board_l+c[1], hat_front_y-hat_part_h, board_top-conn_y[1]]) cube([c[2]-c[1], hat_part_h, conn_y[1]-conn_y[0]]);
  color("#222") translate([board_l+hat_jack[0], hat_front_y-hat_part_h, board_top-hat_jack[3]]) cube([hat_jack[1]-hat_jack[0], hat_part_h, hat_jack[3]-hat_jack[2]]);   // headset jack
  color("silver") translate([board_r-3.5, usb_yc-usb_rec_h/2, usb_z-3.75]) cube([3.5+usb_protrude, usb_rec_h, 7.5]);     // micro-USB receptacle
  color("orange") for (z = pin_zones) translate([board_l+z[0], 0, board_top-z[3]]) cube([z[1]-z[0], pin_len, z[3]-z[2]]);   // THT pins behind the board
  for (q=hat_leds) color("red") at_xz(bp(q)) ycyl(2, hat_front_y-0.9, hat_front_y);
  for (q=hat_mics) color("black") at_xz(bp(q)) ycyl(3, hat_front_y-1.0, hat_front_y);
  color("gold") for (q=hat_holes) at_xz(bp(q)) translate([0,baffle_t-tube_loc_depth,0]) rotate([-90,0,0]) tube();
  color("#333") sd_dummy();   // v3.7
}
pin_len = 2.0;
pin_zones = [pin_row];   // measured pin row (board coords)
module pins_dummy(grow=0) { for (z = pin_zones) translate([board_l+z[0]-grow, 0, board_top-z[3]-grow]) cube([z[1]-z[0]+2*grow, pin_len, z[3]-z[2]+2*grow]); }
echo(str("PIN RELIEF: depth ", pin_relief_depth, " -> panel remaining ", baffle_t-pin_relief_depth, " mm; zone x ", pin_relief_zone[0], "..", pin_relief_zone[1], " y ", pin_relief_zone[2], "..", pin_relief_zone[3], " (board coords)"));
// v3.6: filler tooth on the grille's right frame back. Fills the 45 deg roof triangle of the USB notch above the plug
// and the strip in front of it (0.5 mm to the 10 x 7 plug and the notch floor, 0.3 mm normal clearance to the roof). Printed face-down its top is a 45 deg face
// that shrinks upwards = self-supporting. It locally fills the fabric glue channel (cut a slit in the cloth there).
usb_fill_x = [W - wall + 0.2, W - 0.1];   // v3.7: same tooth relative to the (moved) side wall
usb_fill_zb = usb_z + usb_plug[0]/2 + 0.5;
usb_fill_y1 = 0.5;
function usb_roof(y) = usb_z + usb_plug[0]/2 + usb_margin + (usb_yc + usb_plug[1]/2 + usb_margin - y);   // notch roof height at depth y
module usb_filler() {
  c = 0.3*sqrt(2); ys = y_cb - ch_d - 0.2;
  yf = usb_yc - usb_plug[1]/2 - 0.5;                       // 0.5 in front of the plug
  zl = usb_z - usb_plug[0]/2 - usb_margin + 0.5;           // 0.5 above the notch floor
  module prof(y0) polygon([[y0, zl], [yf, zl], [yf, usb_fill_zb], [usb_fill_y1, usb_fill_zb], [usb_fill_y1, usb_roof(usb_fill_y1)-c], [y0, usb_roof(y0)-c]]);
  xext(usb_fill_x[0], usb_fill_x[1]-usb_fill_x[0]) prof(y_cb - 0.01);              // on the solid frame rim / channel
  intersection() { xext(usb_fill_x[0], W-ch_off-usb_fill_x[0]) prof(ys);             // plug in the glue channel only (stays off the R3 edge)
                   translate([0, -50, 0]) cube([W, 50+y_cb+0.01, H_tot]); }
}
// v3.7: Pi Zero 2 W microSD card (user photo: slot on the left short edge, header on top, card ~3 mm proud, card ~7-18 mm
// from the header edge). In the case: right edge, on the component side (facing the HAT), header edge = board bottom.
sd_out = 3.2;
module sd_dummy() { translate([board_r-13, pi_front_y-1.6, board_top-pcb_h+7]) cube([13+sd_out, 1.6, 11]); }
module usb_plug_dummy() {   // user's plug body 10 x 7 mm, 20 mm long, inserted from the right
  color("#333") translate([board_r+0.6, usb_yc-usb_plug[1]/2, usb_z-usb_plug[0]/2]) cube([20, usb_plug[1], usb_plug[0]]);
}
module plunger_placed() { at_xz(bp(hat_btn)) translate([0, btn_top_y-0.3, 0]) rotate([90,0,0]) plunger(); }
module diffuser_placed() { at_xz(led_c) translate([-seat[0]/2+diff_clear, y_pi, -seat[1]/2+diff_clear]) rotate([90,0,0]) mirror([0,0,1]) led_diffuser(); }

// ---------------- fasteners (views + collision check) ----------------
module hexnut(af, h) { cylinder(d=af/cos(30), h=h, $fn=6); }
module button_screw(d, l, dk, k) { translate([0,0,-k]) cylinder(d=dk, h=k); cylinder(d=d, h=l); }  // under-head at z=0
lid_uh_z = H_tot - lid_cb_h;
show_fallback = true;
module fasteners() {
  color("#111") for (h = spk_holes) at_xz(h) {
    translate([0, -spk_washer, 0]) rotate([-90,0,0]) button_screw(3, spk_screw_l, m3_dk, m3_k);
    color("silver") ycyl(7, -spk_washer, 0);
    translate([0, spk_nut_seat, 0]) rotate([-90,30,0]) hexnut(m3_af, m3_nut_h);
  }
  color("#111") for (i = [0:5]) translate([screws[i][0], screws[i][1], 0]) {
    translate([0,0,lid_uh_z]) mirror([0,0,1]) button_screw(3, lid_screw_l, m3_dk, m3_k);
    translate([0,0,lid_nut_z-m3_nut_h]) rotate(slot_dirs[i]) hexnut(m3_af, m3_nut_h);
  }
  if (show_fallback) color("#111") for (i = [0,1]) let(t = side_tabs[i]) translate([0, fb_y, fb_z(t)]) {
    if (i==0) { translate([fb_cb_h,0,0]) rotate([0,90,0]) button_screw(2, fb_screw_l, m2_dk, m2_k);
                translate([t[0]+1.2,0,0]) rotate([0,90,0]) rotate([0,0,30]) hexnut(m2_af, m2_nut_h); }
    else      { translate([W-fb_cb_h,0,0]) rotate([0,-90,0]) button_screw(2, fb_screw_l, m2_dk, m2_k);
                translate([t[0]+t[2]-1.2-m2_nut_h,0,0]) rotate([0,90,0]) rotate([0,0,30]) hexnut(m2_af, m2_nut_h); }
  }
  color("#111") for (q = hat_holes) at_xz(bp(q)) {
    translate([0, hat_front_y, 0]) rotate([-90,0,0]) button_screw(2.5, hat_screw_l, m25_dk, m25_k);   // M2.5x16 through-bolt
    translate([0, pi_front_y+pcb_t, 0]) rotate([-90,30,0]) hexnut(m25_af, m25_nut_h);                  // nut on the Pi back
  }
}
// stack-ups (echoed): protrusion beyond the nut must be >= 1.5 threads
spk_grip  = spk_washer + spk_frame_t + (baffle_t - spk_frame_t) + (spk_nut_seat - baffle_t);
lid_grip  = (lid_t - lid_cb_h) + gasket_c + lid_nut_top;
stack_grip = pcb_t + (baffle_t - tube_loc_depth) + tube_len + pcb_t;   // = HAT front face -> Pi back face
fb_grip   = (wall - fb_cb_h) + 0.2 + 1.2;
echo(str("JOINT grille FALLBACK M2x", fb_screw_l, ": grip ", fb_grip, " + nut ", m2_nut_h, " -> protrusion ", fb_screw_l-fb_grip-m2_nut_h, " (min ", 1.5*m2_pitch, ")"));
echo(str("JOINT speaker M3x", spk_screw_l, "+washer: grip ", spk_grip, " + nut ", m3_nut_h, " -> protrusion ", spk_screw_l-spk_grip-m3_nut_h, " (min ", 1.5*m3_pitch, ")"));
echo(str("JOINT lid M3x", lid_screw_l, ": grip ", lid_grip, " (foam ", gasket_c, ") + nut ", m3_nut_h, " -> protrusion ", lid_screw_l-lid_grip-m3_nut_h));
echo(str("JOINT HAT+Pi through-bolt M2.5x", hat_screw_l, ": HAT ", pcb_t, " + panel ", baffle_t-tube_loc_depth, " + tube ", tube_len, " + Pi ", pcb_t, " = grip ", stack_grip,
         " + nut ", m25_nut_h, " -> protrusion ", hat_screw_l-stack_grip-m25_nut_h, " (want >= 0.7); thread engagement in nut ", min(m25_nut_h, hat_screw_l-stack_grip), " mm = ", min(m25_nut_h, hat_screw_l-stack_grip)/m25_pitch, " threads"));
echo(str("Board gap ", stack_h, "; tube ", tube_len, " (OD ", tube_od, ", ID ", tube_id, "); needed screw for 0.7 protrusion: ", stack_grip+m25_nut_h+0.7));
echo(str("USB: receptacle centre z=", usb_z, " (", hat_usb_y, " below HAT top), y=", usb_yc, "; notch z ", usb_z-usb_plug[0]/2-usb_margin, "..", usb_z+usb_plug[0]/2+usb_margin,
         ", y ", -recess, "..", usb_yc+usb_plug[1]/2+usb_margin));
assert(hat_screw_l - stack_grip > 1.0, "M2.5 through-bolt does not reach the nut");

// ---------------- air volume behind the driver (measured from the STL) ----------------
module cavity() {
  difference() {
    intersection() { xext(wall, W_in) inner2d(0); cube([W, 300, H_tub]); }
    body(); lid();
  }
}

// ---------------- original (for the comparison render) ----------------
module original() {
  multmatrix([[0,0,-1,0],[-1,0,0,0],[0,1,0,0],[0,0,0,1]]) {
    color("#8a8f98") import("original/zip/Jarvis Box.stl");
    color("#b0b5bd") import("original/zip/Jarvis Deckel.stl");
    color("#30343b") import("original/zip/Jarvis Grill.stl");
    color("orange") import("original/zip/Jarvis Tube.stl");
  }
}

// ---------------- print orientation ----------------
module lid_print()    { translate([0,0,H_tot]) rotate([180,0,0]) children(); }   // top face down
module grille_print() { translate([0,0,-y_pf]) rotate([90,0,0]) children(); }     // front face down
module assembled(e=0) {
  color("#6b7280") body();
  color("#9ca3af") translate([0,0,e*35]) lid();
  color("#374151", 0.95) translate([0,-e*45,0]) grille();
  color("white", 0.85) translate([0,-e*45,0]) diffuser_placed();
  translate([0,-e*20,0]) speaker_dummy();
  translate([0,-e*12,0]) hat_dummy();
  translate([0,-e*12,0]) fasteners();
  color("white") translate([0,-e*30,0]) plunger_placed();
}
// ---------------- test pieces (all in print orientation, z=0 on the bed) ----------------
tl0 = tongue_x0(latch_x[0]);
module test_corner()   { translate([0,0,-68]) intersection() { body(); translate([-1, -recess-1, 68]) cube([33, 26, 30]); } }
module test_hat()      { z0 = board_top-pcb_h-4; translate([0,0,-z0]) intersection() { body(); translate([board_l-4, -recess-1, z0]) cube([W-board_l+5, 18, pcb_h+18]); } }
module test_clip_lid() { lid_print() intersection() { lid(); translate([tl0-4, -recess-1, H_tub-5]) cube([tongue_L+10, 13, 15]); } }
module test_clip_grille() { grille_print() intersection() { grille(); translate([tab_xc(latch_x[0])-tab_w/2-7.5, y_pf-1, H_tot-14]) cube([tab_w+15, 20, 15]); } }
module test_hinge_body()  { intersection() { body(); translate([hook_x[0]-14, -recess-1, -1]) cube([28, 14, 9]); } }
module test_hinge_grille(){ grille_print() intersection() { grille(); translate([hook_x[0]-hook_w/2-6, y_pf-1, -1]) cube([hook_w+12, 20, 12]); } }
module test_led()      { bt = bp(hat_btn); grille_print() intersection() { grille(); translate([led_c[0]-15, y_pf-1, led_c[1]-10]) cube([bt[0]-led_c[0]+24, 20, 20]); } }

// ---------------- v3.4 QUICK TEST (small, minimal filament) ----------------
qt_alt = 0.10;   // '+' variant: nut_clear + 0.10
module qt_hex(af, clear, h) { cylinder(d=(af+clear)/cos(30), h=h, $fn=6); }
module qt_label(t, sz=3.2) { linear_extrude(0.6) text(t, size=sz, halign="center", valign="center", font="Liberation Sans:style=Bold"); }
// (a)+(b) wall coupon printed like the panel: horizontal clearance holes, press-in pockets on the back face, vertex up
qt_holes = [[6, 3, m3_af, m3_nut_h, m3_clear, 0, "3"], [17, 3, m3_af, m3_nut_h, m3_clear, qt_alt, "3+"],
            [28, 2.5, m25_af, m25_nut_h, hat_hole_d, 0, "2.5"], [39, 2.5, m25_af, m25_nut_h, hat_hole_d, qt_alt, "2.5+"]];
module qt_wall() {
  difference() {
    union() { translate([0, 0, 0]) cube([45, 4, 12]); translate([0, -8, 0]) cube([45, 8.01, 1.2]); }
    for (h = qt_holes) translate([h[0], 0, 7]) {
      ycyl(h[4], -1, 5);
      translate([0, 4-(h[3]+0.3), 0]) rotate([-90,30,0]) qt_hex(h[2], nut_clear+h[5], h[3]+1);
    }
  }
  for (h = qt_holes) translate([h[0], -4, 1.2-eps]) qt_label(h[6], 3.0);
}
// (b) lid-boss style: pocket opens DOWN (here: onto the bed), screw from the top, bearing face = bridge
module qt_lidblock() {
  hh = m3_nut_h + 0.3 + lid_nut_top;
  difference() {
    cube([24, 11, hh]);
    for (i = [0,1]) translate([6 + i*12, 5.5, 0]) {
      translate([0,0,-1]) cylinder(d=m3_clear, h=hh+2);
      translate([0,0,-1]) qt_hex(m3_af, nut_clear + i*qt_alt, m3_nut_h+0.3+1);
      translate([0,0,-eps]) cylinder(d1=(m3_af+nut_clear+i*qt_alt)/cos(30)+0.8, d2=(m3_af+nut_clear+i*qt_alt)/cos(30), h=0.4, $fn=6);  // mouth chamfer vs elephant foot
    }
  }
  for (i = [0,1]) translate([6 + i*12 + (i==0 ? 0 : 0), 9.2, hh-eps]) qt_label(i==0 ? "0" : "+", 2.6);
}
// (f) speaker corner: top-left screw hole + nut pocket + seat ring + 2.8 mm drop + stiffening ring, printed upright
qt_spk_box = [spk_holes[1][0]-8, spk_cx-14, spk_holes[1][1]-15, spk_holes[1][1]+10];   // x0, x1, z0, z1
module qt_spk() {   // + 1.2 mm foot plate behind the front face (the section's own footprint is narrow)
  translate([0,0,1.2-qt_spk_box[2]]) intersection() { body();
    translate([qt_spk_box[0], -2, qt_spk_box[2]]) cube([qt_spk_box[1]-qt_spk_box[0], 18, qt_spk_box[3]-qt_spk_box[2]]); }
  translate([qt_spk_box[0], 0, 0]) cube([qt_spk_box[1]-qt_spk_box[0], 10, 1.2+eps]);
}
// (d)+(e) seat piece: grille section with the LED window/diffuser seat and the button guide (= test_led)
if (part=="qt_wall")     qt_wall();
if (part=="qt_lidblock") qt_lidblock();
if (part=="qt_spk")      qt_spk();

if (part=="body")     body();
if (part=="lid")      lid_print() lid();
if (part=="grille")   grille_print() grille();
if (part=="spacer")   tube();
if (part=="plunger")  plunger();
if (part=="diffuser") led_diffuser();
if (part=="cavity")   cavity();
if (part=="assembly") assembled(0);
if (part=="exploded") assembled(1);
if (part=="nogrille") { color("#6b7280") body(); speaker_dummy(); hat_dummy(); fasteners(); usb_plug_dummy(); }
if (part=="open_top") { color("#6b7280") body(); speaker_dummy(); hat_dummy(); fasteners(); }
if (part=="section")  intersection() { assembled(0); translate([-50,-50,-1]) cube([W+100, 300, bp(hat_mics[0])[1]]); }
if (part=="section_joints") intersection() { assembled(0); translate([-50,-50,-1]) cube([W+100, 300, bp(hat_holes[0])[1]+0.6+1]); }
if (part=="section_hat_lid") intersection() { assembled(0); translate([-50,-50,-50]) cube([board_l+hat_holes[1][0]+50+0.1, 300, 300]); }
if (part=="section_led") intersection() { assembled(0); translate([-50,-50,-1]) cube([W+100, 300, led_c[1]+1]); }
if (part=="section_side") intersection() { assembled(0); translate([-1,-50,-50]) cube([spk_cx+1, 300, 300]); }
if (part=="section_latch") intersection() { assembled(0); translate([-50,-50,-50]) cube([tab_xc(latch_x[0])+50, 300, 300]); }
if (part=="section_usb") intersection() { union() { assembled(0); usb_plug_dummy(); } translate([-50,-50,-50]) cube([W+100, 300, usb_z+50]); }
if (part=="test_corner")       test_corner();
if (part=="test_hat")          test_hat();
if (part=="test_clip_lid")     test_clip_lid();
if (part=="test_clip_grille")  test_clip_grille();
if (part=="test_hinge_body")   test_hinge_body();
if (part=="test_hinge_grille") test_hinge_grille();
if (part=="test_led")          test_led();
if (part=="compare")  { assembled(0); translate([-150, 0, 0]) original();
  color("black") { translate([-150+63, -20, -14]) rotate([90,0,0]) linear_extrude(1) text("original #638687  126x56x80", size=6, halign="center");
                   translate([W/2, -20, -14]) rotate([90,0,0]) linear_extrude(1) text(str("v3.3  ", W, "x", H_tot, "x", yb_bot+recess+fab_gap+cap_d), size=6, halign="center"); } }
