update vt_precinct_monitor as pm
set current = pm.current + s.current
from
    view_import_current as s
where
    pm.precinct_id = s.precinct_id;
