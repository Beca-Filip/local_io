function m = numEqualityConstraints(obj)
%NUMEQUALITYCONSTRAINTS returns the number of equality constraint functions
%in DO.

m = length(obj.eqconstraintvector);
return
end