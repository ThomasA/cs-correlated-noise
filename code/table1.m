% This script retrieves the parameters shown in Table I in the paper.
load quant_model_params

display([1-beta_lm([1 3 5])' 1-beta_u([1 3 5])'])
