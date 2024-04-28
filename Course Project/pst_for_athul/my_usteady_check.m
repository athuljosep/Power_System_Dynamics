% small step size dc state derivatives

dc_fields = {
    'di_dci',
    'di_dcr',
    'dv_coni',
    'dv_conr',
    'dv_dcc',
    'dxdci_dc',
    'dxdcr_dc'
};

nfields = numel(dc_fields);
for ii = 1:nfields
    dc_dstate(ii).field = dc_fields{ii};
    dc_dstate(ii).step1 = eval([dc_fields{ii},'(:,1)']);
    dc_dstate(ii).step2 = eval([dc_fields{ii},'(:,2)']);
end

%----------------------------------------------------------------------------%

if ( max(abs(dEfd)) < 1e-12 )
  tmp = (Efd(:,3:end) - Efd(:,1:end-2))/(2*my_Ts);
  dEfd = [tmp, zeros(size(tmp,1),2)];
end

ac_fields = {
    'dEfd',
    'dedprime',
    'deqprime',
    'dlmod_st',
    'dmac_ang',
    'dmac_spd',
    'dpsikd',
    'dpsikq',
    'dpss1',
    'dpss2',
    'dpss3',
    'dpw_out',
    'dpw_Tz_idx',
    'dR_f',
    'drlmod_st',
    'dsdpw1',
    'dsdpw2',
    'dsdpw3',
    'dsdpw4',
    'dsdpw5',
    'dsdpw6',
    'dslig',
    'dslip',
    'dtg1',
    'dtg2',
    'dtg3',
    'dtg4',
    'dtg5',
    'dV_As',
    'dV_R',
    'dV_TR',
    'dvdp',
    'dvdpig',
    'dvqp',
    'dvqpig',
    'dxsvc_dc',
    'dxtcsc_dc'
};

nfields = numel(ac_fields);
for ii = 1:nfields
    nsamp = size(eval(ac_fields{ii}),2);
    ac_dstate(ii).field = ac_fields{ii};
    if ( nsamp > 0 )
        ac_dstate(ii).step1 = eval([ac_fields{ii},'(:,1)']);
        ac_dstate(ii).step2 = eval([ac_fields{ii},'(:,2)']);
    else
        ac_dstate(ii).step1 = [];
        ac_dstate(ii).step2 = [];
    end
end

% eof
