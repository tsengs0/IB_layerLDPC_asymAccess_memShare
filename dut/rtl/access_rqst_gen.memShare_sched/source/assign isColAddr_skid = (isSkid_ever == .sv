assign isColAddr_skid = (isSkid_ever == 1'b1) ? SKID : 
                        (isGtr == 1'b1 && isColAddr_skid_pipe0 == 1'b0) ? SKID : NOSKID;