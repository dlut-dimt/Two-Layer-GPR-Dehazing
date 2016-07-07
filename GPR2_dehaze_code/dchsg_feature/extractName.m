function name=extractName(str)

name=[];

l=length(str);

j=1;
for i=1:l
    if str(i)~=' ',
       name(j)=str(i);
       j=j+1;
    end;
end;
 
    