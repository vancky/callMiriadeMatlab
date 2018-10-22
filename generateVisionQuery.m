function outURL=generateVisionQuery(targets,varargin)
% This function use to generate URL to query Miriade Vision
% reference http://vo.imcce.fr/webservices/miriade/?vision
% http://vo.imcce.fr/webservices/miriade/?documentation
% inputs :
%          target, cell string ,with one target name in one element
%          The general syntaxe of celestial object names in Miriade.ViSiON is the following:
%             <prefix>:<nom>[=alias]
%             where <prefix> is one of the following codes:
%             ' a ' to point out an asteroid
%             ' c ' to point out a comet
%             ' dp ' to point out a dwarf planet
%             ' e ' to point out any fixed point on the celestial sphere
%             ' p ' to point out a planet or a natural satellite
%             ' u ' to point out a Simbad object 
%             the names of celestial objects outside the solar system must 
%             comply with the Dictionary of Nomenclature of celestial objects of Simbad. 
%             The syntaxe of the names must follow the following rule:
%             <catalogue>_<identifier> | <proper_name>
%             where catalogue is the acronym of the catalogue (e.g., HIP, TYC, ...),
%             where identifier is the identifier of the object (usually a number). 
%             If the numer is composed of a sequence of numbers (e.g. FFFF-NNNNN-N) 
%             then the leading zero must be discarded, e.g. TYC 5595-00982-1 is written TYC_55959821,
%             where proper_name is the usual name of the object (e.g. Polaris, Sirius).
%             Examples: M_31, HIP_11767, Polaris, TYC_55959821
%             the fixed points on the celestial sphere are defined by their equatorial 
%             coordinates (RA,DEC), and must comply the format:
%             <RA>¡À<DEC>
%             with RA and DEC expressed in hours and degrees, formated in decimal or 
%             sexagesimal number (with the character '_' as field separator). It is 
%             recommended to encode the '+' sign of DEC by its term percent-encoding '%2B'.
%             Examples: e:0_10_30%2B45_2_12.4, e:0.175-45.03678
%           varargin, other inputs ,see reference
%             epoch   str, default : now
%             observatory str, default : yaoan
p=inputParser;
p.KeepUnmatched = true;
defaultObservatory='110.179 25.5 2000';
defaultEpoch='now';
defaultNbd=1;
defaultStep=1;
defaultMime='pdf';
validMime={'pdf','html','votable'};
defaultSort='ra';
checkSort=@(x) any(validatestring(x,{'ra','dec','name','mv','diam','type'}));
checkMime=@(x) any(validatestring(x,validMime));
addRequired(p,'targets',@iscell);
addOptional(p,'sort',defaultSort,checkSort);
addOptional(p,'observatory',defaultObservatory,@isstr);
addOptional(p,'epoch',defaultEpoch,@isstr);
addParameter(p,'nbd',defaultNbd,@isinteger);
addParameter(p,'step',defaultStep,@isinteger);
addOptional(p,'mime',defaultMime,checkMime);
parse(p,targets,varargin{:});
disp(targets)
outURL=strcat('http://vo.imcce.fr/webservices/miriade/vision_query.php?',...
    '&-ep=',p.Results.epoch,'&-name=',strjoin(targets,','),...
    sprintf('&-nbd=%d&-step=%d',p.Results.nbd,p.Results.step),...
    sprintf('&-observer=%s',p.Results.observatory),...
    sprintf('&-cuts=&-sort=%s&-mime=%s',p.Results.sort,p.Results.mime));