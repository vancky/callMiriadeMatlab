classdef queryMiriade
    properties
        targetname
        official_name
        start_epoch
        step_size
        nbd
        url
        data
        originSrc
    end
    
    methods % constructor 
        function self = queryMiriade(targetname)
%            
%         Initialize query to Miriade
%         Parameters
%         ----------
%         targetname         : str
%         The general syntaxe of Sso names in Miriade is the following:
% 
%        <prefix>:<name>[/X]
%         where <prefix> is one of the following codes:
%         a to point out an asteroid
%         c to point out a comet
%         dp to point out a dwarf planet
%         p to point out a planet
%         s to point out a natural satellite
%         and where <name> is the official number or name, 
%         or the provisional designation of the Sso. The space 
%         character in the provisional designation of asteroids can be
%         substituted by the underscore ('_') or the HTML character '%20'.
%         Results:
%         self
%            
            if sum(strcmp(targetname(1:2),{'a:','c:','dp','p:','s:'}))==0
                error('target name must prefix with one of the following codes:\n a,c,dp,p or s\n');
            end
            self.targetname = targetname;
            self.start_epoch    ='now';
            self.nbd     = 1;
            self.step_size      = '1d';
            self.url            = nan;
            self.data           = nan;
        end
    end
    methods % set epochs
        function self=set_epochrange(self,start_epoch,step_size,nbd)
%          
%         Set a range of epochs, all times are UT
%         Parameters
%         ----------
%         start_epoch        :    str
%           Examples (non exhaustive) of valid dates:
%         now
%         2006-01-27T1:53:34
%         2453762.529467592
%         10 September 2000
%         +1 day
%         +1 week 2 days 4 hours 2 seconds
%         next Thursday
%         last Monday
%         step_size          :    str
%            epoch step size, e.g., '1d' for 1 day, '10m' for 10 minutes...
%            [Optional parameter, default = '1d']
%          ndb               :   int
%           Number of dates of ephemeris to compute
%           [Optional parameter, default = 1],1 ¡Ü nbd ¡Ü 5000
%         Returns
%         -------
%         None
%         
%         Examples
%         --------
%         >>> ceres =queryqueryMiriade('a:Ceres')
%         >>> ceres=ceres.set_epochrange('now','1d',3)     
%     
            if nargin==4
                self.nbd=nbd;
                  self.step_size   = step_size;
                    self.start_epoch = start_epoch;
            end
            if nargin==3
                self.step_size   = step_size;
                  self.start_epoch = start_epoch;
            end
            if nargin==2
                self.start_epoch = start_epoch;
            end

        end

    end
    properties (Dependent)
        fields
        dates
        queryUrl
        datetimeM
        ephochNo
    end
    methods
        function tt=get.fields(self)
            % returns list of available properties for all epochs
            try
                tt=self.data.Properties.VariableNames;
            catch
                tt=[];
            end
        end
        function tt=get.ephochNo(self)
            % returns total number of epochs that have been queried
            try
                tt=size(self.data,1);
            catch
                tt=0;
            end
        end
        function tt=get.dates(self)
            % returns list of epochs that have been queried (format 'YYYY-MM-DD HH-MM-SS')
            try
                tt=self.data{:,'epoch'};
            catch
                tt=[];
            end
        end
        function tt=get.queryUrl(self)
            % returns URL that has been used in calling Miriade
            try
                tt=self.url;
            catch
                tt=[];
            end
        end
        function tt=get.datetimeM(self)
            % returns list of epochs that have been queried (Matlab date time format)
            try
                tt=self.data{:,'datetimeM'};
            catch
                tt=[];
            end
        end
        function tt=briefInfo(self)
            %returns brief query information
            tt=sprintf('<callmiriade.query object: %s>',self.targetname);
        end
        function tt=getitem(self,key,k)
%             
%             provides access to query data
% 
%         Parameters
%         ----------
%         key          : str/int
%            epoch index or property key
% 
%         Returns
%         -------
%         query data according to key
% 
%            
            
            if isempty(self.data)
                disp('CALLMIRIADE ERROR: run get_ephemerides first');
                tt=nan;
            else
                if nargin>2&&max(k)<=self.ephochNo&&min(k)>0
                    tt=self.data{k,key};
                elseif nargin>2&&(max(k)>self.ephochNo||min(k)<0)&&k~=':'
                     error('out of index')
                else
                    tt=self.data{:,key};
                end
            end
        end
    end
    methods
        function self=get_ephemerides(self,observatory)
%              
%         Call IMCCE Miriade website to obtain ephemerides based on the
%         provided targetname, epochs, and observatory_code. For a list
%         of valid observatory codes, refer to
%         http://minorplanetcenter.net/iau/lists/ObsCodesF.html
%         Parameters
%         ----------
%         observatory_code     : str/int
%            observer's location code according to Minor Planet Center 
%            or  [+-]longitude [+-]latitude altitude. The longitude and 
%            latitude must be expressed in decimal degrees, and the altitude
%             in meters. Longitudes are negative toward East. The sign + of 
%             the longitude and latitude can be omitted. 
%            or @0 (SSB) @sun @earth 
%              eg. 'O44' '110.179 25.5 2000'
%         
%         Examples
%         --------
%         >>> ceres = queryMiriade('Ceres')
%         >>> ceres=ceres.set_epochrange('2016-02-23T00:00:00', '1h',5)
%         >>> ceres=ceres.get_ephemerides('O44');
%         >>> ceres.getitem('ra',1)
%         >>> ceres.data(:,'ra')
%         >>> ceres.data{:,'ra'}         
            switch nargin
                case 1
                    observatory='110.179 25.5 2000';% a default station for YAAT

            end
            % queried fields (see Miriade website for details)
            % http://vo.imcce.fr/webservices/miriade/?ephemcc#outputoptions
            % if fields are added here, also update the field identification below
            % encode objectname for use in URL
            if ischar(observatory)
            else
                observatory=int2str(observatory);
            end
            tmpurl=strcat('http://vo.imcce.fr/webservices/miriade/ephemcc_query.php?',...
                '&-name=',self.targetname,'&-type=&-ep=',self.start_epoch,...
                sprintf('&-nbd=%d&-step=%s',self.nbd,self.step_size),...
                '&-observer=',observatory,'&-tcoor=5&-mime=json');
            self.url=tmpurl;
            webOption=weboptions('Timeout',60);
         %   disp(self.url);
          try  src=webread(self.url,webOption);
          catch
              fprintf('seems your network failed, or you can try the url with your webrows\n');
              disp(self.url);
              error('WEB READ FAILED');
          end
          try  self.official_name=src.sso.name;
          catch
              self.official_name=src.sso.iau_name;
          end
            self.originSrc=src;
            tTable=cell2table(struct2cell(src.data)');
            tTable.Properties.VariableNames=fieldnames(src.data);
            tTable.datetimeM=datetime(tTable.epoch,'InputFormat','yyyy-MM-dd''T''HH:mm:ss.SS','TimeZone','+0');
            self.data=tTable;
        end
end
end
