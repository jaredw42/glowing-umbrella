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
    msg.acq_result(i).cn0 = arr(1);
    msg.acq_result(i).cp = arr(2);
    msg.acq_result(i).cf = arr(3);
    
    arr = fread(a,2,'uint8');
    msg.acq_result(i).sid = arr(1);
    msg.acq_result(i).code = arr(2);
    
    msg.acq_result(i).cksum = fread(a,1,'uint16');
    
    tot_msg_acqresult = tot_msg_acqresult + 1;
    msgtype = -99;
end
   
%% msg_age_corrections

if msgtype == 528 % hex 210
    fseek(a,startpayload,-1);

    
    i = tot_msg_age_corr;
    
    msg.age_corrections(i,1).tow = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint16');
    msg.age_corrections(i,1).age = arr(1) / 10 ;
    msg.age_corrections(i,1).cksum = arr(2);
   
    tot_msg_age_corr = tot_msg_age_corr + 1;
    msgtype = -99;
    
end

%% msg_almanac_glo

if msgtype == 115 % hex 0x0073
        
    i = tot_msg_ephemglo;
    
    arr = fread(a,2,'uint8');
    msg.almanac_glo(i).sid = arr(1);
    msg.almanac_glo(i).code = arr(2);
    
    msg.almanac_glo(i).tow = fread(a,1,'uint32');
    msg.almanac_glo(i).wn = fread(a,1,'uint16');
    msg.almanac_glo(i).ura = fread(a,1,'double');
    msg.almanac_glo(i).fitint = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    msg.almanac_glo(i).valid = arr(1);
    msg.almanac_glo(i).health = arr(2);
    
    arr = fread(a,7,'double');
    msg.almanac_glo(i).lamda_na = arr(1);
    msg.almanac_glo(i).t_lamda_na = arr(2);
    msg.almanac_glo(i).i = arr(3);
    msg.almanac_glo(i).t = arr(4);
    msg.almanac_glo(i).tdot = arr(5);
    msg.almanac_glo(i).epsilon = arr(6);
    msg.almanac_glo(i).omega = arr(7);
end
%% msg_almanac_gps

if msgtype == 134 % hex 0x0086
    
    fseek(a,startpayload,-1);
    i = tot_msg_ephemgps;
    
    arr = fread(a,2,'uint8');
    msg.almanac_gps(i).sid = arr(1);
    msg.almanac_gps(i).code = arr(2);
    
    msg.almanac_gps(i).tow = fread(a,1,'uint32');
    msg.almanac_gps(i).wn = fread(a,1,'uint16');
    msg.almanac_gps(i).ura = fread(a,1,'double');
    msg.almanac_gps(i).fitint = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    msg.almanac_gps(i).valid = arr(1);
    msg.almanac_gps(i).health = arr(2);
    
    arr = fread(a,9,'double');
    msg.almanac_gps(i).m0 = arr(1);
    msg.almanac_gps(i).ecc = arr(2);
    msg.almanac_gps(i).sqrta = arr(3);
    msg.almanac_gps(i).omega0 = arr(4);
    msg.almanac_gps(i).omegadot = arr(5);
    msg.almanac_gps(i).w = arr(6);
    msg.almanac_gps(i).inc = arr(7);
    msg.almanac_gps(i).af0 = arr(8);
    msg.almanac_gps(i).af1 = arr(9);

    
    tot_msg_almgps = tot_msg_almgps + 1;
    msgtype = -99;
    
end

%% msg_baseline_ecef

if msgtype == 523 % hex 20b
    fseek(a,startpayload,-1);
    i = tot_msg_bl_ecef ;
    msg.bl_ecef(i).tow = fread(a,1,'uint32');
    
    arr = fread(a,3,'int32');
    msg.bl_ecef(i).x = arr(1);
    msg.bl_ecef(i).y = arr(2);
    msg.bl_ecef(i).z = arr(3);
    
    msg.bl_ecef(i).estacc = fread(a,1,'uint16');
    msg.bl_ecef(i).n_sats = fread(a,1,'uint8');
    msg.bl_ecef(i).flags = fread(a,1,'uint8');
    
    tot_msg_bl_ecef = tot_msg_bl_ecef + 1;
    msgtype = -99;
end
  

%% msg_baseline_ned

if msgtype == 524 % hex 20c
    fseek(a,startpayload,-1);
    i = tot_msg_bl_ned ;
    msg.bl_ned(i).tow = fread(a,1,'uint32');
    
    arr = fread(a,3,'int32');
    msg.bl_ned(i).n = arr(1);
    msg.bl_ned(i).e = arr(2);
    msg.bl_ned(i).d = arr(3);
    
    msg.bl_ned(i).h_acc = fread(a,1,'uint16');
    msg.bl_ned(i).v_acc = fread(a,1,'uint16');
    msg.bl_ned(i).n_sats = fread(a,1,'uint8');
    msg.bl_ned(i).flags = fread(a,1,'uint8');
    
    tot_msg_bl_ned = tot_msg_bl_ned + 1;
    msgtype = -99;
end


%% msg_baseline_heading

if msgtype == 527 % hex 0x020F
    
    fseek(a,startpayload,-1);
    i = tot_msg_bl_hdg;
    
    arr = fread(a,2,'uint32');
    msg.bl_hdg(i).tow = arr(1);
    msg.bl_hdg(i).mdeg = arr(2);
    
    arr = fread(a,2,'uint8');
    msg.bl_hdg(i).n_sats = arr(1);
    msg.bl_hdg(i).flags = arr(2);
    
    tot_msg_bl_hdg = tot_msg_bl_hdg + 1;
    msgtype = -99;  
    
end

%% msg_base_pos_ecef

if msgtype == 72 % hex 0x0048
    
    i = tot_msg_baseposecef;
    fseek(a,startpayload, -1);
    
    arr = fread(a,3,'double');
    msg.base_pos_ecef(i).x = arr(1);
    msg.base_pos_ecef(i).y = arr(2); 
    msg.base_pos_ecef(i).z = arr(3);
    
    msg.base_pos_ecef(i).cksum = fread(a,1,'uint16');
    tot_msg_baseposecef = tot_msg_baseposecef + 1;
    msgtype = -99;
    
end
   
%% msg_base_pos_llh

if msgtype == 68 % hex 0x0044
    
    i = tot_msg_baseposllh;
    fseek(a,startpayload, -1);
    
    arr = fread(a,3,'double');
    msg.base_pos_llh(i).lat = arr(1);
    msg.base_pos_llh(i).lon = arr(2); 
    msg.base_pos_llh(i).height = arr(3);
    
    msg.base_pos_llh(i).cksum = fread(a,1,'uint16');
    tot_msg_baseposllh = tot_msg_baseposllh + 1;
    msgtype = -99;
    
end
%% msg_dgnss_status

if msgtype == 65282 % hex FF02
    
    fseek(a,startpayload,-1);
    
    i = tot_msg_dgnssstat;
    msg.dgnss_status(i).flags = fread(a,1,'uint8');
    msg.dgnss_status(i).latency = fread(a,1,'uint16');
    msg.dgnss_status(i).n_signals = fread(a,1,'uint8');
    msg.dgnss_status(i).source = fread(a,1,'uint8') ; % THIS SHOULD BE A STRING BUT WAS ALWAYS PRINTING BINARY 
                                                        % so changed to read
    tot_msg_dgnssstat = tot_msg_dgnssstat + 1;                    %bit insead 
    msgtype = -99;
end
%% msg_dops

if msgtype == 520 % hex 208

    fseek(a,startpayload,1);
    i = tot_msg_dops;
    msg.dops(i).towms = fread(a,1,'uint32');

    arr = fread(a,5,'uint16');
    arr = arr * 0.01;
    msg.dops(i).gdop = arr(1);
    msg.dops(i).pdop = arr(2);
    msg.dops(i).tdop = arr(3) ;
    msg.dops(i).hdop = arr(4);
    msg.dops(i).vdop = arr(5);
    msg.dops(i).cksum = fread(a,1,'uint16');

    tot_msg_dops = tot_msg_dops + 1;
    msgtype = -99;


end

%% msg_ephemeris_glo

if msgtype == 136 % hex 0x0088
        
    i = tot_msg_ephemglo;
    
    arr = fread(a,2,'uint8');
    msg.ephem_glo(i).sid = arr(1);
    msg.ephem_glo(i).code = arr(2);
    
    msg.ephem_glo(i).tow = fread(a,1,'uint32');
    msg.ephem_glo(i).wn = fread(a,1,'uint16');
    msg.ephem_glo(i).ura = fread(a,1,'double');
    msg.ephem_glo(i).fitint = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    msg.ephem_glo(i).valid = arr(1);
    msg.ephem_glo(i).health = arr(2);
    
    arr = fread(a,6,'double');
    msg.ephem_glo(i).gamma = arr(1);
    msg.ephem_glo(i).tau = arr(2);
    msg.ephem_glo(i).d_tau = arr(3);
    msg.ephem_glo(i).pos = arr(4);
    msg.ephem_glo(i).vel = arr(5);
    msg.ephem_glo(i).acc = arr(6);
    
    arr = fread(a,6,'uint8');
    msg.ephem_glo(i).fcn = arr(1);
    msg.ephem_glo(i).iod = arr(2);
    
    msg.ephem_glo(i).cksum = fread(a,1,'uint16');
    
    tot_msg_ephemglo = tot_msg_ephemglo + 1;
    msgtype = -99;
    
end
%% msg_ephemeris_gps

if msgtype == 134 % hex 0x0086
    
    fseek(a,startpayload,-1);
    i = tot_msg_ephemgps;
    
    arr = fread(a,2,'uint8');
    msg.ephem_gps(i).sid = arr(1);
    msg.ephem_gps(i).code = arr(2);
    
    msg.ephem_gps(i).tow = fread(a,1,'uint32');
    msg.ephem_gps(i).wn = fread(a,1,'uint16');
    msg.ephem_gps(i).ura = fread(a,1,'double');
    msg.ephem_gps(i).fitint = fread(a,1,'uint32');
    
    arr = fread(a,2,'uint8');
    msg.ephem_gps(i).valid = arr(1);
    msg.ephem_gps(i).health = arr(2);
    
    arr = fread(a,19,'double');
    msg.ephem_gps(i).tgd = arr(1);
    msg.ephem_gps(i).c_rs = arr(2);
    msg.ephem_gps(i).c_rc = arr(3);
    msg.ephem_gps(i).c_uc = arr(4);
    msg.ephem_gps(i).c_us  = arr(5);
    msg.ephem_gps(i).c_ic = arr(6);
    msg.ephem_gps(i).c_is = arr(7);
    msg.ephem_gps(i).dn = arr(8);
    msg.ephem_gps(i).m0 = arr(9);
    msg.ephem_gps(i).ecc = arr(10);
    msg.ephem_gps(i).sqrta = arr(11);
    msg.ephem_gps(i).omega0 = arr(12);
    msg.ephem_gps(i).omegadot = arr(13);
    msg.ephem_gps(i).w = arr(14);
    msg.ephem_gps(i).inc = arr(15);
    msg.ephem_gps(i).incdot = arr(16);
    msg.ephem_gps(i).af0 = arr(17);
    msg.ephem_gps(i).af1 = arr(18);
    msg.ephem_gps(i).af2 = arr(19); %woo hoo that is done
    
    msg.ephem_gps(i).toctow = fread(a,1,'uint32');
    msg.ephem_gps(i).tocwn = fread(a,1,'uint16');
    msg.ephem_gps(i).iode = fread(a,1,'uint8');
    msg.ephem_gps(i).iodc = fread(a,1,'uint16');
    msg.ephem_gps(i).cksum = fread(a,1,'uint16');
    
    tot_msg_ephemgps = tot_msg_ephemgps + 1;
    msgtype = -99;
    
end

%% msg_iono

if msgtype == 144 %hex 0x0090
    
    fseek(a,startpayload,-1);
    i = tot_msg_iono;
    
    msg.iono(i).tow = fread(a,1,'uint32');
    msg.iono(i).wn = fread(a,1,'uint16');
    
    arr = fread(a,8,'double');
    msg.iono(i).a0 = arr(1);
    msg.iono(i).a1 = arr(2);
    msg.iono(i).a2 = arr(3);
    msg.iono(i).a3 = arr(4);
    msg.iono(i).b0 = arr(5);
    msg.iono(i).b1 = arr(6);
    msg.iono(i).b2 = arr(7);
    msg.iono(i).b3 = arr(8);
    
    msg.iono(i).cksum = fread(a,1,'uint16');
    
    tot_msg_iono = tot_msg_iono + 1;
    msgtype = -99;
    
end

%% msg_glo_biases

if msgtype == 117 % hex 0x0075
    
    i = tot_msg_globias;
    fseek(a,startpayload, -1);
    
    msg.glo_bias(i).mask = fread(a,1,'uint8');
    arr = fread(a,4,'int16');
    msg.glo_bias(i).l1ca_bias = arr(1);
    msg.glo_bias(i).l1p_bias = arr(2);
    msg.glo_bias(i).l2ca_bias = arr(3);
    msg.glo_bias(i).l2p_bias = arr(4);
    
    msg.glo_bias(i).cksum = fread(a,1,'uint16');   
    tot_msg_globias = tot_msg_globias + 1;
    msgtype = -99;
    
end

   %% msg_gps_time
   if msgtype == 258 % hex 0x0102
       i = tot_msg_gpstime;
       msg.gps_time(i).wn = fread(a,1,'uint16');
       msg.gps_time(i).tow = fread(a,1,'uint32');
       msg.gps_time(i).ns_res = fread(a,1,'int32');
       msg.gps_time(i).flags = fread(a,1,'uint8');

       msg.gps_time(i).cksum = fread(a,1,'uint16') ;

       tot_msg_gpstime = tot_msg_gpstime + 1;
       msgtype = -99;
   end
%% msg_group_delay

if msgtype == 148 % hex 0x0094
    
    i = tot_msg_grpdelay;
    fseek(a,startpayload,-1);
    
    msg.grp_delay(i).tow = fread(a,1,'uint32');
    msg.grp_delay(i).wn = fread(a,1,'uint16');
    
    arr = fread(a,3,'uint8');
    msg.grp_delay(i).sid = arr(1);
    msg.grp_delay(i).code = arr(2);
    msg.grp_delay(i).valid = arr(3);
    
    arr = fread(a,3,'int16');
    msg.grp_delay(i).tgd = arr(1);
    msg.grp_delay(i).isc_l1ca = arr(2);
    msg.grp_delay(i).isc_l2c = arr(3);    
    
    msg.grp_delay(i).cksum = fread(a,1,'uint16');
    tot_msg_grpdelay = tot_msg_grpdelay + 1;
    msgtype = -99;

end
   %% msg_log

if msgtype == 1025 % msg_log - hex 0401
   fseek(a,startpayload,-1);
   i = tot_msg_log;
   msg.log(i).lvl = fread(a, 1, 'uint8');
   msg.log(i).msg = fscanf(a, '%c', msglen);
   msg.log(i).cksum = fread(a,1,'uint16');

   tot_msg_log = tot_msg_log + 1;
   msgtype = -99;


end
 
   %% msg_mag_raw
   
if msgtype == 2306 % hex 902
    
    i = tot_msg_mag;
    fseek(a,startpayload, -1);
    
    msg.mag_raw(i).tow = fread(a,1,'uint32');
    msg.mag_raw(i).tow_f = fread(a,1,'uint8') / 256;
    
    arr = fread(a,4,'int16');
    msg.mag_raw(i).x = arr(1);
    msg.mag_raw(i).y = arr(2);
    msg.mag_raw(i).z = arr(3);
    msg.mag_raw(i).cksum = arr(4);
    
   tot_msg_mag = tot_msg_mag + 1;
   msgtype = -99;
   
end

%% msg_pos_ecef

    if msgtype == 521 % hex 209
        fseek(a,startpayload, -1);
        
        msg.pos_ecef(i).tow = fread(a,1,'uint32');
        
        arr = fread(a,3,'double');
        msg.pos_ecef(i).x = arr(1);
        msg.pos_ecef(i).y = arr(2);
        msg.pos_ecef(i).z = arr(3);
        
        arr = fread(a,1,'uint16');
        msg.pos_ecef(i).esth_acc = arr(1);
       
        
        arr = fread(a,2,'uint8');
        msg.pos_ecef(i).n_sats = arr(1);
        msg.pos_ecef(i).flags = arr(2);
        
        msg.pos_ecef(i).cksum = fread(a,1,'uint16');
        tot_msg_posecef = tot_msg_posecef + 1;
        msgtype = -99;
    end
    
 %% msg_pos_llh
    if msgtype == 522 % hex 20A
        i = tot_msg_posllh;
        fseek(a,startpayload, -1);
        
        msg.pos_llh(i).tow = fread(a,1,'uint32');
        
        arr = fread(a,3,'double');
        msg.pos_llh(i).lat = arr(1);
        msg.pos_llh(i).lon = arr(2);
        msg.pos_llh(i).elev = arr(3);
        
        arr = fread(a,2,'uint16');
        msg.pos_llh(i).esth_acc = arr(1);
        msg.pos_llh(i).estv_acc = arr(2);
        
        arr = fread(a,2,'uint8');
        msg.pos_llh(i).n_sats = arr(1);
        msg.pos_llh(i).flags = arr(2);
        
        msg.pos_llh(i).cksum = fread(a,1,'uint16');
        
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

        msg.obs(i).tow = tow;
        msg.obs(i).pseudorng = fread(a,1,'uint32');
        msg.obs(i).cphase_w = fread(a,1,'int32'); %carrier phase whole
        msg.obs(i).cphase_f = fread(a,1,'uint8') / 256;
        msg.obs(i).dopp_w = fread(a,1,'int16');
        
        arr = fread(a,6,'uint8');
        
        msg.obs(i).dopp_f = arr(1)/256;
        msg.obs(i).cn0 = arr(2) / 4;
        msg.obs(i).lock = arr(3);
        msg.obs(i).flags = arr(4);
        msg.obs(i).sid = arr(5);
        msg.obs(i).band = arr(6);
        msg.obs(i).fileloc = ftell(a);
        
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
    
    msg.svconfig_gps(i).tow = fread(a,1,'uint32');
    msg.svconfig_gps(i).wn = fread(a,1,'uint16');
    msg.svconfig_gps(i).l2cmsk = fread(a,1,'uint32');
    
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
    msg.utc_time(i).flags = fread(a,1,'uint8');
    msg.utc_time(i).tow = fread(a,1,'uint32');
    msg.utc_time(i).year = fread(a,1,'uint16');
    
    arr = fread(a,5,'uint8');
    
    msg.utc_time(i).month = arr(1);
    msg.utc_time(i).day = arr(2);
    msg.utc_time(i).hour = arr(3);
    msg.utc_time(i).minutes = arr(4);
    msg.utc_time(i).seconds = arr(5);
    
    msg.utc_time(i).ns = fread(a,1,'uint32');
    tot_msg_utctime = tot_msg_utctime + 1 ;
    
    msgtype = -99;
end

    
%% msg_vel_ecef
if msgtype == 525 %hex 0x020D
    i = tot_msg_velecef;
    
    fseek(a,startpayload, -1);
        
        msg.vel_ecef(i).tow = fread(a,1,'uint32');
        
        arr = fread(a,3,'int32');
        msg.vel_ecef(i).x = arr(1);
        msg.vel_ecef(i).y = arr(2);
        msg.vel_ecef(i).z = arr(3);
        
        msg.vel_ecef(i).est_acc =fread(a,1,'uint16');

        arr = fread(a,2,'uint8');
        msg.vel_ecef(i).n_sats = arr(1);
        msg.vel_ecef(i).flags = arr(2);
        
        msg.vel_ecef(i).cksum = fread(a,1,'uint16');
        
        tot_msg_velecef = tot_msg_velecef + 1;
        
        msgtype = -99;
end

%% msg_vel_ned
    if msgtype == 526 % hex 20E
        i = tot_msg_velned;
        fseek(a,startpayload, -1);
        
        msg.vel_ned(i).tow = fread(a,1,'uint32');
        
        arr = fread(a,3,'int32');
        msg.vel_ned(i).n = arr(1);
        msg.vel_ned(i).e = arr(2);
        msg.vel_ned(i).d = arr(3);
        
        arr = fread(a,2,'uint16');
        msg.vel_ned(i).esth_acc = arr(1);
        msg.vel_ned(i).estv_acc = arr(2);
        
        arr = fread(a,2,'uint8');
        msg.vel_ned(i).n_sats = arr(1);
        msg.vel_ned(i).flags = arr(2);
        
        msg.vel_ned(i).cksum = fread(a,1,'uint16');
        
        tot_msg_velned = tot_msg_velned + 1;
        
        msgtype = -99;
        
    end
end
disp('data omped')
toc