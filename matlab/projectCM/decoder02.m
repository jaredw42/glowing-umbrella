%%
% Project CM... a matlab script that omps sbp data


fclose('all');
clearvars

tot_msg_age_corr = 1;
tot_msg_obs  = 1 ;
tot_msg_log = 1;
tot_msg_dops = 1;
tot_msg_velecef  = 1;
tot_msg_velned = 1;
tot_msg_bl_ecef = 1;
tot_msg_bl_ned = 1;
tot_msg_bl_hdg = 1;
tot_msg_gpstime = 1;
tot_msg_posecef = 1;
tot_msg_posllh = 1;
tot_msg_utctime = 1;
tot_msg_acqresult= 1;
tot_msg_dgnssstat = 1;
tot_msg_mag = 1;
tot_msg_ephemglo = 1;
tot_msg_ephemgps = 1;
tot_msg_iono = 1;
tot_msg_baseposecef = 1;
tot_msg_almgps = 1;
tot_msg_globias = 1;
tot_msg_grpdelay = 1;
tot_msg_svconfiggps = 1;
tot_msg_baseposllh = 1;

tabcolnames= {'tow', 'age', 'cksum'}
age_corrections = table(tabcolnames)

fp = '//Users/jwilson/SwiftNav/dev/projectCM/';

fn = '0004-01320.sbp';

sbpid = strcat(fp, fn);
a = fopen(sbpid, 'r', 'l');


% TODO: if (not) one of the message types, skip (fseek) the length of the message 
%% lookin for dat header
% % 
disp('well here goes nothing')
tic
while ~feof(a)

    x = fread(a, 1 ,'uint8');
    
    if x == 85 % hex 55

        msgtype = fread(a, 1, 'uint16');
        %hexmsgtype = dec2hex(msgtype);
       
        sender = fread(a,1,'uint16');
       % hexsender = dec2hex(sender, 4);
        
        msglen = fread(a,1,'uint8');
        startpayload = ftell(a);
        
    else
        
        x = fread(a,50,'uint8');
        b = find(x==85,1) - 1;
        
        if isempty(b) == false && length(x) == 50
            
            brev = (50-b) * (-1);
            fseek(a,brev,0);
        
            x = fread(a,1,'uint8');
        
            if x == 85
                
                msgtype = fread(a, 1, 'uint16');
                %hexmsgtype = dec2hex(msgtype);

                sender = fread(a,1,'uint16');
                % hexsender = dec2hex(sender, 4);
        
                msglen = fread(a,1,'uint8');
                startpayload = ftell(a);
            end
        end
        
        
         
        
    end
%% msg_acq_result

if msgtype == 47
    i = tot_msg_acqresult;
    fseek(a,startpayload, -1);
    
    
    arr = fread(a,3,'float');
    acq_result.cn0(i,1)= arr(1);
    acq_result.cp(i,1) = arr(2);
    acq_result.cf(i,1) = arr(3);
    
    arr = fread(a,2,'uint8');
    acq_result.sid(i,1) = arr(1);
    acq_result.code(i,1) = arr(2);
    
    acq_result.cksum(i,1) = fread(a,1,'uint16');
    
    tot_msg_acqresult = tot_msg_acqresult + 1;
    msgtype = -99;
end
   
%% msg_age_corrections

if msgtype == 528 % hex 210
    fseek(a,startpayload,-1);

    
    i = tot_msg_age_corr;
    
    age_corrections.tow(i,1) = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint16');
    age_corrections.age(i,1) = arr(1) / 10 ;
    age_corrections.cksum(i,1) = arr(2);
   
    tot_msg_age_corr = tot_msg_age_corr + 1;
    msgtype = -99;
    
end

%% msg_almanac_glo

if msgtype == 115 % hex 0x0073
        
    i = tot_msg_ephemglo;
    
    arr = fread(a,2,'uint8');
    almanac_glo.sid(i,1) = arr(1);
    almanac_glo.code(i,1) = arr(2);
    
    almanac_glo.tow(i,1) = fread(a,1,'uint32');
    almanac_glo.wn(i,1) = fread(a,1,'uint16');
    almanac_glo.ura(i,1) = fread(a,1,'double');
    almanac_glo.fitint(i,1) = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    almanac_glo.valid(i,1) = arr(1);
    almanac_glo.health(i,1) = arr(2);
    
    arr = fread(a,7,'double');
    almanac_glo.lamda_na(i,1) = arr(1);
    almanac_glo.t_lamda_na(i,1) = arr(2);
    almanac_glo.i(i,1) = arr(3);
    almanac_glo.t(i,1) = arr(4);
    almanac_glo.tdot(i,1) = arr(5);
    almanac_glo.epsilon(i,1) = arr(6);
    almanac_glo.omega(i,1) = arr(7);
end
%% msg_almanac_gps

if msgtype == 134 % hex 0x0086
    
    fseek(a,startpayload,-1);
    i = tot_msg_ephemgps;
    
    arr = fread(a,2,'uint8');
    almanac_gps.sid(i,1) = arr(1);
    almanac_gps.code(i,1) = arr(2);
    
    almanac_gps.tow(i,1) = fread(a,1,'uint32');
    almanac_gps.wn(i,1) = fread(a,1,'uint16');
    almanac_gps.ura(i,1) = fread(a,1,'double');
    almanac_gps.fitint(i,1) = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    almanac_gps.valid(i,1) = arr(1);
    almanac_gps.health(i,1) = arr(2);
    
    arr = fread(a,9,'double');
    almanac_gps.m0(i,1) = arr(1);
    almanac_gps.ecc(i,1) = arr(2);
    almanac_gps.sqrta(i,1) = arr(3);
    almanac_gps.omega0(i,1) = arr(4);
    almanac_gps.omegadot(i,1) = arr(5);
    almanac_gps.w(i,1) = arr(6);
    almanac_gps.inc(i,1) = arr(7);
    almanac_gps.af0(i,1) = arr(8);
    almanac_gps.af1(i,1) = arr(9);

    
    tot_msg_almgps = tot_msg_almgps + 1;
    msgtype = -99;
    
end

%% msg_baseline_ecef

if msgtype == 523 % hex 20b
    fseek(a,startpayload,-1);
    i = tot_msg_bl_ecef ;
    bl_eceftow = fread(a,1,'uint32');
    
    arr = fread(a,3,'int32');
    bl_ecef.x(i,1) = arr(1);
    bl_ecef.y(i,1) = arr(2);
    bl_ecef.z(i,1) = arr(3);
    
    bl_ecef.estacc(i,1) = fread(a,1,'uint16');
    bl_ecef.n_sats(i,1) = fread(a,1,'uint8');
    bl_ecef.flags(i,1) = fread(a,1,'uint8');
    
    tot_msg_bl_ecef = tot_msg_bl_ecef + 1;
    msgtype = -99;
end
  

%% msg_baseline_ned

if msgtype == 524 % hex 20c
    fseek(a,startpayload,-1);
    i = tot_msg_bl_ned ;
    bl_nedtow = fread(a,1,'uint32');
    
    arr = fread(a,3,'int32');
    bl_ned.n(i,1) = arr(1);
    bl_ned.e(i,1) = arr(2);
    bl_ned.d(i,1) = arr(3);
    
    bl_ned.h_acc(i,1) = fread(a,1,'uint16');
    bl_ned.v_acc(i,1) = fread(a,1,'uint16');
    bl_ned.n_sats(i,1) = fread(a,1,'uint8');
    bl_ned.flags(i,1) = fread(a,1,'uint8');
    
    tot_msg_bl_ned = tot_msg_bl_ned + 1;
    msgtype = -99;
end


%% msg_baseline_heading

if msgtype == 527 % hex 0x020F
    
    fseek(a,startpayload,-1);
    i = tot_msg_bl_hdg;
    
    arr = fread(a,2,'uint32');
    bl_hdg.tow(i,1) = arr(1);
    bl_hdg.mdeg(i,1) = arr(2);
    
    arr = fread(a,2,'uint8');
    bl_hdg.n_sats(i,1) = arr(1);
    bl_hdg.flags(i,1) = arr(2);
    
    tot_msg_bl_hdg = tot_msg_bl_hdg + 1;
    msgtype = -99;  
    
end

%% msg_base_pos_ecef

if msgtype == 72 % hex 0x0048
    
    i = tot_msg_baseposecef;
    fseek(a,startpayload, -1);
    
    arr = fread(a,3,'double');
    base_pos_ecef.x(i,1) = arr(1);
    base_pos_ecef.y(i,1) = arr(2); 
    base_pos_ecef.z(i,1) = arr(3);
    
    base_pos_ecef.cksum = fread(a,1,'uint16');
    tot_msg_baseposecef = tot_msg_baseposecef + 1;
    msgtype = -99;
    
end
   
%% msg_base_pos_llh

if msgtype == 68 % hex 0x0044
    
    i = tot_msg_baseposllh;
    fseek(a,startpayload, -1);
    
    arr = fread(a,3,'double');
    base_pos_llh.lat(i,1) = arr(1);
    base_pos_llh.lon(i,1) = arr(2); 
    base_pos_llh.height(i,1) = arr(3);
    
    base_pos_llh.cksum(i,1) = fread(a,1,'uint16');
    tot_msg_baseposllh = tot_msg_baseposllh + 1;
    msgtype = -99;
    
end
%% msg_dgnss_status

if msgtype == 65282 % hex FF02
    
    fseek(a,startpayload,-1);
    
    i = tot_msg_dgnssstat;
    dgnss_status.flags(i,1) = fread(a,1,'uint8');
    dgnss_status.latency(i,1) = fread(a,1,'uint16');
    dgnss_status.n_signals(i,1) = fread(a,1,'uint8');
    dgnss_status.source(i,1) = fread(a,1,'uint8') ; % THIS SHOULD BE A STRING BUT WAS ALWAYS PRINTING BINARY 
                                                        % so changed to read
    tot_msg_dgnssstat = tot_msg_dgnssstat + 1;                    %bit insead 
    msgtype = -99;
end
%% msg_dops

if msgtype == 520 % hex 208

    fseek(a,startpayload,1);
    i = tot_msg_dops;
    dopstow.ms(i,1) = fread(a,1,'uint32');

    arr = fread(a,5,'uint16');
    arr = arr * 0.01;
    dops.gdop(i,1) = arr(1);
    dops.pdop(i,1) = arr(2);
    dops.tdop(i,1) = arr(3) ;
    dops.hdop(i,1) = arr(4);
    dops.vdop(i,1) = arr(5);
    dops.cksum(i,1) = fread(a,1,'uint16');

    tot_msg_dops = tot_msg_dops + 1;
    msgtype = -99;


end

%% msg_ephemeris_glo

if msgtype == 136 % hex 0x0088
        
    i = tot_msg_ephemglo;
    
    arr = fread(a,2,'uint8');
    ephem_glo.sid(i,1) = arr(1);
    ephem_glo.code(i,1) = arr(2);
    
    ephem_glo.tow(i,1) = fread(a,1,'uint32');
    ephem_glo.wn(i,1) = fread(a,1,'uint16');
    ephem_glo.ura(i,1) = fread(a,1,'double');
    ephem_glo.fitint(i,1) = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    ephem_glo.valid(i,1) = arr(1);
    ephem_glo.health(i,1) = arr(2);
    
    arr = fread(a,6,'double');
    ephem_glo.gamma(i,1) = arr(1);
    ephem_glo.tau(i,1) = arr(2);
    ephem_glo.d_tau(i,1) = arr(3);
    ephem_glo.pos(i,1) = arr(4);
    ephem_glo.vel(i,1) = arr(5);
    ephem_glo.acc(i,1) = arr(6);
    
    arr = fread(a,6,'uint8');
    ephem_glo.fcn(i,1) = arr(1);
    ephem_glo.iod(i,1) = arr(2);
    
    ephem_glo.cksum(i,1) = fread(a,1,'uint16');
    
    tot_msg_ephemglo = tot_msg_ephemglo + 1;
    msgtype = -99;
    
end
%% msg_ephemeris_gps

if msgtype == 134 % hex 0x0086
    
    fseek(a,startpayload,-1);
    i = tot_msg_ephemgps;
    
    arr = fread(a,2,'uint8');
    ephem_gps.sid(i,1) = arr(1);
    ephem_gps.code(i,1) = arr(2);
    
    ephem_gps.tow(i,1) = fread(a,1,'uint32');
    ephem_gps.wn(i,1) = fread(a,1,'uint16');
    ephem_gps.ura(i,1) = fread(a,1,'double');
    ephem_gps.fitint(i,1) = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    ephem_gps.valid(i,1) = arr(1);
    ephem_gps.health(i,1) = arr(2);
    
    arr = fread(a,19,'double');
    ephem_gps.tgd(i,1) = arr(1);
    ephem_gps.c_rs(i,1) = arr(2);
    ephem_gps.c_rc(i,1) = arr(3);
    ephem_gps.c_uc(i,1) = arr(4);
    ephem_gps.c_us(i,1)  = arr(5);
    ephem_gps.c_ic(i,1) = arr(6);
    ephem_gps.c_is(i,1) = arr(7);
    ephem_gps.dn(i,1) = arr(8);
    ephem_gps.m0(i,1) = arr(9);
    ephem_gps.ecc(i,1) = arr(10);
    ephem_gps.sqrta(i,1) = arr(11);
    ephem_gps.omega0(i,1) = arr(12);
    ephem_gps.omegadot(i,1) = arr(13);
    ephem_gps.w(i,1) = arr(14);
    ephem_gps.inc(i,1) = arr(15);
    ephem_gps.incdot(i,1) = arr(16);
    ephem_gps.af0(i,1) = arr(17);
    ephem_gps.af1(i,1) = arr(18);
    ephem_gps.af2(i,1)= arr(19); %woo hoo that is done
    
    ephem_gps.toctow(i,1) = fread(a,1,'uint32');
    ephem_gps.tocwn(i,1) = fread(a,1,'uint16');
    ephem_gps.iode(i,1) = fread(a,1,'uint8');
    ephem_gps.iodc(i,1) = fread(a,1,'uint16');
    ephem_gps.cksum(i,1) = fread(a,1,'uint16');
    
    tot_msg_ephemgps = tot_msg_ephemgps + 1;
    msgtype = -99;
    
end

%% msg_iono

if msgtype == 144 %hex 0x0090
    
    fseek(a,startpayload,-1);
    i = tot_msg_iono;
    
    iono.tow(i,1) = fread(a,1,'uint32');
    iono.wn(i,1) = fread(a,1,'uint16');
    
    arr = fread(a,8,'double');
    iono.a0(i,1) = arr(1);
    iono.a1(i,1) = arr(2);
    iono.a2(i,1) = arr(3);
    iono.a3(i,1) = arr(4);
    iono.b0(i,1) = arr(5);
    iono.b1(i,1) = arr(6);
    iono.b2(i,1) = arr(7);
    iono.b3(i,1) = arr(8);
    
    iono.cksum(i,1) = fread(a,1,'uint16');
    
    tot_msg_iono = tot_msg_iono + 1;
    msgtype = -99;
    
end

%% msg_glo_biases

if msgtype == 117 % hex 0x0075
    
    i = tot_msg_globias;
    fseek(a,startpayload, -1);
    
    glo_bias.mask(i,1) = fread(a,1,'uint8');
    arr = fread(a,4,'int16');
    glo_bias.l1ca_bias(i,1) = arr(1);
    glo_bias.l1p_bias(i,1) = arr(2);
    glo_bias.l2ca_bias(i,1) = arr(3);
    glo_bias.l2p_bias(i,1) = arr(4);
    
    glo_bias.cksum = fread(a,1,'uint16');   
    tot_msg_globias = tot_msg_globias + 1;
    msgtype = -99;
    
end

   %% msg_gps_time
   if msgtype == 258 % hex 0x0102
       i = tot_msg_gpstime;
       gps_time.wn(i,1) = fread(a,1,'uint16');
       gps_time.tow(i,1) = fread(a,1,'uint32');
       gps_time.ns_res(i,1) = fread(a,1,'int32');
       gps_time.flags(i,1) = fread(a,1,'uint8');

       gps_time.cksum = fread(a,1,'uint16') ;

       tot_msg_gpstime = tot_msg_gpstime + 1;
       msgtype = -99;
   end
%% msg_group_delay

if msgtype == 148 % hex 0x0094
    
    i = tot_msg_grpdelay;
    fseek(a,startpayload,-1);
    
    grp_delay.tow(i,1) = fread(a,1,'uint32');
    grp_delay.wn(i,1) = fread(a,1,'uint16');
    
    arr = fread(a,3,'uint8');
    grp_delay.sid(i,1) = arr(1);
    grp_delay.code(i,1) = arr(2);
    grp_delay.valid(i,1) = arr(3);
    
    arr = fread(a,3,'int16');
    grp_delay.tgd(i,1) = arr(1);
    grp_delay.isc_l1ca(i,1) = arr(2);
    grp_delay.isc_l2c(i,1) = arr(3);    
    
    grp_delay.cksum(i,1) = fread(a,1,'uint16');
    tot_msg_grpdelay = tot_msg_grpdelay + 1;
    msgtype = -99;

end
   %% msg_log

if msgtype == 1025 % msg_log - hex 0401
   fseek(a,startpayload,-1);
   i = tot_msg_log;

   logmsg.lvl(i,1) = fread(a, 1, 'uint8');
   logmsg.msg{i} = fscanf(a, '%c', msglen);
   logmsg.cksum(i,1) = fread(a,1,'uint16');

   tot_msg_log = tot_msg_log + 1;
   msgtype = -99;


end
 
   %% msg_mag_raw
   
if msgtype == 2306 % hex 902
    
    i = tot_msg_mag;
    fseek(a,startpayload, -1);
    
    mag_rawtow = fread(a,1,'uint32');
    mag_rawtow_f = fread(a,1,'uint8') / 256;
    
    arr = fread(a,4,'int16');
    mag_raw.x(i,1) = arr(1);
    mag_raw.y(i,1) = arr(2);
    mag_raw.z(i,1) = arr(3);
    mag_raw.cksum(i,1) = arr(4);
    
   tot_msg_mag = tot_msg_mag + 1;
   msgtype = -99;
   
end

%% msg_pos_ecef

    if msgtype == 521 % hex 209
        fseek(a,startpayload, -1);
        
        pos_ecef.tow(i,1) = fread(a,1,'uint32');
        
        arr = fread(a,3,'double');
        pos_ecef.x(i,1) = arr(1);
        pos_ecef.y(i,1) = arr(2);
        pos_ecef.z(i,1) = arr(3);
        
        arr = fread(a,1,'uint16');
        pos_ecef.h_acc(i,1) = arr(1);
       
        
        arr = fread(a,2,'uint8');
        pos_ecef.n_sats(i,1) = arr(1);
        pos_ecef.flags(i,1) = arr(2);
        
        pos_ecefcksum = fread(a,1,'uint16');
        tot_msg_posecef = tot_msg_posecef + 1;
        msgtype = -99;
    end
    
 %% msg_pos_llh
    if msgtype == 522 % hex 20A
        i = tot_msg_posllh;
        fseek(a,startpayload, -1);
        
        pos_llh.tow(i,1) = fread(a,1,'uint32');
        
        arr = fread(a,3,'double');
        pos_llh.lat(i,1) = arr(1);
        pos_llh.lon(i,1) = arr(2);
        pos_llh.elev(i,1) = arr(3);
        
        arr = fread(a,2,'uint16');
        pos_llh.esth_acc(i,1) = arr(1);
        pos_llh.estv_acc(i,1) = arr(2);
        
        arr = fread(a,2,'uint8');
        pos_llh.n_sats(i,1) = arr(1);
        pos_llh.flags(i,1) = arr(2);
        
        pos_llh.cksum(i,1) = fread(a,1,'uint16');
        
        tot_msg_posllh = tot_msg_posllh + 1;
        msgtype = -99;
    end

%% msg_obs


if msgtype == 74 %binary value of msg_obs, hex is 004A
    
   tow = fread(a,1,'uint32');
   ns_residual = fread(a,1,'int32');
   wn = fread(a,1,'uint16');
   n_obs = fread(a,1,'uint8');
   
   while ftell(a) < startpayload + msglen

   obsheaderend = ftell(a);
    i = tot_msg_obs;

        obs.tow(i,1) = tow;
        obs.pseudorng(i,1) = fread(a,1,'uint32');
        obs.cphase_w(i,1) = fread(a,1,'int32'); %carrier phase whole
        obs.cphase_f(i,1) = fread(a,1,'uint8') / 256;
        obs.dopp_w(i,1) = fread(a,1,'int16');
        
        arr = fread(a,6,'uint8');
        
        obs.dopp_f(i,1) = arr(1)/256;
        obs.cn0(i,1) = arr(2) / 4;
        obs.lock(i,1) = arr(3);
        obs.flags(i,1) = arr(4);
        obs.sid(i,1) = arr(5);
        obs.band(i,1) = arr(6);
        obs.fileloc(i,1) = ftell(a);
        
        tot_msg_obs = tot_msg_obs + 1;
        i = tot_msg_obs;
        
     % if ftell(a) == startpayload + msglen
        %  disp('obs good')
 
      if ftell(a) > startpayload + msglen
          disp('obs failure probable')    
      end
 
   end
    cksum = fread(a,1,'uint16');
    msgtype = -99;
end

%% msg_sv_configuration_gps

if msgtype == 145 % hex 0x0091
    
    fseek(a,startpayload,-1);
    i = tot_msg_svconfiggps;
    
    svconfig_gps.tow(i,1) = fread(a,1,'uint32');
    svconfig_gps.wn(i,1) = fread(a,1,'uint16');
    svconfig_gps.l2cmsk(i,1) = fread(a,1,'uint32');
    
    tot_msg_svconfiggps = tot_msg_svconfiggps + 1;
    msgtype = -99;
    
end
    
%% msg_thread_state 

if msgtype == 23 % hex 0x001D
%    disp('skpping msg_thread_state for lack of decoder info')
%     fseek(a,startpayload,-1)
%     x = fread(a,20,'char')
fseek(a,20,0);
msgtype = -99;
end


%% msg_utc_time

if msgtype == 259 %hex 0x0103
    i = tot_msg_utctime;
    utc_time.flags(i,1) = fread(a,1,'uint8');
    utc_time.tow(i,1) = fread(a,1,'uint32');
    utc_time.year(i,1) = fread(a,1,'uint16');
    
    arr = fread(a,5,'uint8');
    
    utc_time.month(i,1) = arr(1);
    utc_time.day(i,1) = arr(2);
    utc_time.hour(i,1) = arr(3);
    utc_time.minutes(i,1) = arr(4);
    utc_time.seconds(i,1) = arr(5);
    
    utc_timens = fread(a,1,'uint32');
    tot_msg_utctime = tot_msg_utctime + 1 ;
    
    msgtype = -99;
end

    
%% msg_vel_ecef
if msgtype == 525 %hex 0x020D
    i = tot_msg_velecef;
    
    fseek(a,startpayload, -1);
        
        vel_eceftow = fread(a,1,'uint32');
        
        arr = fread(a,3,'int32');
        vel_ecef.x(i,1) = arr(1);
        vel_ecef.y(i,1) = arr(2);
        vel_ecef.z(i,1) = arr(3);
        
        vel_ecefest_acc =fread(a,1,'uint16');

        arr = fread(a,2,'uint8');
        vel_ecef.n_sats(i,1) = arr(1);
        vel_ecef.flags(i,1) = arr(2);
        
        vel_ecefcksum = fread(a,1,'uint16');
        
        tot_msg_velecef = tot_msg_velecef + 1;
        
        msgtype = -99;
end

%% msg_vel_ned
    if msgtype == 526 % hex 20E
        i = tot_msg_velned;
        fseek(a,startpayload, -1);
        
        vel_nedtow = fread(a,1,'uint32');
        
        arr = fread(a,3,'int32');
        vel_ned.n(i,1) = arr(1);
        vel_ned.e(i,1) = arr(2);
        vel_ned.d(i,1) = arr(3);
        
        arr = fread(a,2,'uint16');
        vel_ned.esth_acc(i,1) = arr(1);
        vel_ned.estv_acc(i,1) = arr(2);
        
        arr = fread(a,2,'uint8');
        vel_ned.nsats(i,1) = arr(1);
        vel_ned.flags(i,1) = arr(2);
        
        vel_ned.cksum(i,1) = fread(a,1,'uint16');
        
        tot_msg_velned = tot_msg_velned + 1;
        
        msgtype = -99;
        
    end
end
disp('data omped')
toc