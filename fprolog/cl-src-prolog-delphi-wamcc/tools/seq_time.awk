
BEGIN        { max_time = 0
	     }
/completed/ {  cpu_time = $11
               if (cpu_time > max_time)
                       max_time = cpu_time
	     }
END          { print prog "\t" group_count "\t" limit "\t" max_time }
