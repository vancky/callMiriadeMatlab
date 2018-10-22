# callMiriadeMatlab
call IMCCE miriade ephemeris service with matlab 
# three steps to use this class
1. set the target 
   a=queryMiriade('a:135356');
   for asteroid, use a: in front of its name;
   for planets,  use p: in front of its name, e.g p:Neptune;
   for comet,    use c: in front of its name, e.g c:67P; 
   for satellite,use s: in front of its name, e.g s:Nereid;
2. set the epoch , step , numbers . ALL ARE OPTIONAL
    a=a.set_epochrange('2018-10-22T21:12:21','1d',5);
    the default epoch is 'now',default step is '1d',default number is 1;
3.  get the ephemeris with observatory. parameters is optional.
    a=a.get_ephemeris();% for default observatory in yaoan.
    a=a.get_ephemeris('O44'); % for observatory in Lijiang

Then you can see the data for useage, e.g.  a.data
