function adderCostFunction(obj, callableFun)
%ADDERCOSTFUNCTION adds a callable cost function to the DO cost 
%function vector.

obj.do_costfunctionvector{end+1, 1} = callableFun;

end