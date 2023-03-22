function adderEqualityConstraintFunction(obj, callableFun)
%ADDEREQUALITYCONSTRAINTFUNCTION adds a callable equality constraint 
%function to the DO equality constraint function vector.

obj.do_eqconstraintvector{end+1, 1} = callableFun;

end