function res=Delay_NN(h,t_end,x0,neuralOdeParameters)
    
    t_end=h:h:t_end;
    %x0_kw_vec=vec_re_koorn_approx(t_kw,x0,size(x0,1),dim);
    y_pred=dlode45(@odeModel,t_end,dlarray(x0),neuralOdeParameters,DataFormat="CB");
    res=extractdata(y_pred(:,1,:));
    res=reshape(res,size(res,1),size(res,3));
    res=sum(double(res));
end

function y = odeModel(~,y,theta)

    y = tanh(theta.fc1.Weights*y + theta.fc1.Bias);
    y = tanh(theta.fc2.Weights*y + theta.fc2.Bias);
    y = theta.fc3.Weights*y + theta.fc3.Bias;

end