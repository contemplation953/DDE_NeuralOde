function xsolu=dl_ddeab4(fun,par,delay,hist,time)
    dim=length(hist(time(1)));
    h=time(2)-time(1);
    Maxdelay = max(ceil(max(delay)/h)*h,h);
    timehist=fliplr(time(1)-Maxdelay:h:time(1));
    z0=dlarray(zeros(dim,length(timehist)));
    for i=1:length(timehist)
        z0(:,i)=hist(timehist(i));
    end
    z0=z0(:);
    xsolu=dlarray(zeros(dim,length(time)));
    for kk=1:length(time)
        timestep
        tnew=time(kk);
        if kk==1
            znew=z0;
        else
            xold=zold(1:dim);
            Z = reshape(zold,[dim length(timehist)]);
            xdelay = interp1(fliplr(timehist),...
            fliplr(Z)', time(1)-delay)';
            xdelay = reshape(xdelay,[],1);
            rhs1=fun(told,xold,xdelay,par);
            % calculation of the solution
            if kk==2
                xnew = xold+h*rhs1;
            elseif kk==3
                xnew = xold+h*(3*rhs1-rhs2)/2;
            elseif kk==4
            xnew = xold+h*(23*rhs1-16*rhs2+5*rhs3)/12;
            elseif kk>4
                xnew=xold+h*(55*rhs1-59*rhs2+37*rhs3-9*rhs4)/24;
            end
            znew=[xnew;zold(1:end-dim)];
        end

        if kk>3
            rhs4=rhs3;
        end

        if kk>2
            rhs3=rhs2;
        end

        if kk>1
            rhs2=rhs1;
        end
        told=tnew;
        zold=znew;
        xsolu(:,kk)=znew(1:dim);
    end