## callMiriadeMatlab
call IMCCE miriade ephemeris service with matlab 
## three steps to use this class
1. set the target 
 ```matlab
   tareget=queryMiriade('a:135356');
```
   for asteroid, use a: in front of its name;

   for planets,  use p: in front of its name, e.g p:Neptune;

   for comet,    use c: in front of its name, e.g c:67P; 

   for satellite,use s: in front of its name, e.g s:Nereid;

2. set the epoch , step , numbers . ALL ARE OPTIONAL
```matlab
    tareget=target.set_epochrange('2018-10-22T21:12:21','1d',5);
```
the default epoch is 'now',default step is '1d',default number is 1;

3.  get the ephemeris with observatory. parameter is optional.
```matlab
    tareget=tareget.get_ephemeris();% for default observatory in yaoan.
    tareget=tareget.get_ephemeris('O44'); % for observatory in Lijiang
```
## Then you can see the data for useage

```matlab
''''
target.originSrc % the origin source from Horizon 
target.data      % the formated ephemrides from source , a matlab table format 
target.official_name % check the name of object
target.getitme('RA',1)  % get the first RA
target.data{1,'RA'} % the same to the up 
target.getitme('RA',:)  % get all RA  
target.fields % show all items  
''''
```
