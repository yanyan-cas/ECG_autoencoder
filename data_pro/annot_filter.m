function [frm_annot,filter_time] = annot_filter(annot,atrtime)

% We now just care about the annot below 17,so we filter the annot beyound
% 16.Mapping of MIT-BIH arrhythmia database heartbeat types to the AAMI
% heartbeat classes.
% AAMI hearbeat classes
% on-ectopic beats(N),Supraventricular ectopic beats(S),Ventricular ectopic
% beats(V),Fusion beats(F),Unknown beats(Q)
%
%% AAMI hearbeat classes  MIT-BIH heartbeat classes              labels
%          N            NORMAL/* normal beat */                           1   
% 	       N            LBBB/* left bundle branch block beat */             2
% 	       N            RBBB/* right bundle branch block beat */            3
%          N            NESC/* nodal (junctional) escape beat */            11
%          N            AESC/* atrial escape beat */                      34
%          S            ABERR/* aberrated atrial premature beat */          4
%          S            NPC/* nodal (junctional) premature beat */          7
%          S            APC/* atrial premature contraction */               8
%          S            SVPB/* premature or ectopic supraventricular beat*/   9 
%          V            VESC/* ventricular escape beat */                  10
%          V            PVC/* premature ventricular contraction */           5
%          V            FLWAV/* ventricular flutter wave */                 31
%          F            FUSION/* fusion of ventricular and normal beat */     6
%          Q            PACE/* paced beat */                              12
%          Q            UNKNOWN/* unclassifiable beat */                    13
%          Q            PFUS/* fusion of paced and normal beat */            38  

Ac_index = find(annot <= 13 | annot ==31 | annot == 34 | annot == 38);
frm_annot = annot(Ac_index,1);
filter_time = atrtime(Ac_index,1);

end
