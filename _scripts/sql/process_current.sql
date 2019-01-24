update vt_precinct_monitor
set current = s.current_sum
from
    vt_precinct_monitor pm
    inner join (
        select precinct_id, sum(current) as current_sum
        from
            view_current
        group by
            municipality_id,
            precinct_id
        ) s on (s.precinct_id = pm.precinct_id);

