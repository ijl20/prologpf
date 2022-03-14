/started/ {cpustr = substr($1,5)
           rbracket = index(cpustr,")")
           cpu = substr(cpustr, 1, rbracket - 1)
	     }

/limit/ {limit = substr($4,7)}


/completed/ {ftimestr = substr($3,7)
             ms = index(ftimestr, "ms")
             ftime = substr(ftimestr,1,ms - 1)
	       }

/solution/ {sol_count = $4
            print limit "\t" cpu "\t" sol_count "\t" ftime
	      }

