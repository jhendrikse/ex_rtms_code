function corvect = ordered_corvect(cormat,keep)

% corvect = ordered_corvect(cormat,keep)
%
% This function will vectorize a sub-section of a correlation matrix in an
% ordered format. The value are ordered such that if there are k ROIs, the
% all independent correlations for ROI1 are listed first, then ROI2, and so
% on to ROI k. E.g, for a matrix wit four ROIs, the values would be:
% ROI1-ROI2 r
% ROI1-ROI3 r
% ROI1-ROI4 r
% ROI2-ROI3 r
% ROI2-ROI4 r
% ROI3-ROI4 r
%
% ------
% INPUTS
% ------
% cormat        - an N x N x M matrix of correlation values (N=number of 
%                 regions; M= number of subjects)
% keep          - a vector of indices listing which ROIs to keep; i.e., the
%                 output will only retain values for pairs of ROIs indexed by this
%                 vector
%
% ------
% OUTPUT
% ------
% corvect       - a P x M matrix, where P is the number of independent
%                 correlation values (as described above) and M is the
%                 number of subjects
%
% Alex Fornito, University of Melbourne, May 2011
%__________________________________________________________________________


for i=1:size(cormat,3)
    
    C=cormat(keep,:,i);
    C=C(:,keep);
    
    inds=2:size(C,2);
    
    V=[];
    for j=1:size(C,2)
        if j==1
            V=C(j,inds)';
            
            if ~isempty(inds)
                inds(1)=[];
            end
        else
            V=[V; C(j,inds)'];
            if ~isempty(inds)
                inds(1)=[];
            end
        end    
    end
    corvect(i,:)=V;
end