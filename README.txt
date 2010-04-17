- ask sam about wind station- fix quote + know anything about it?

Roster:
- Hard constraints
  - Only actual sailing days (e.g. no duty when Grand Prix, Christmas)
  - Must have 1+ OOD-qualified person 
  - Must have 2+ people with power boat license (besides OOD)
  - 6 duty crew in total per sailing day (OOD + 5)
  - A person cannot be picked for a particular day more than once
- Soft constraints
  - Minimize repetitions any person has to do
  - New members should be rostered sooner in the schedule
  - Maximize days between repetitions for each person
- Additional requirements
  - Be able to adjust roster (e.g. add/remove a person to a particular day manually, once roster generated)
  - Be able to make a person more likely/less likely to be picked for roster (e.g. some people are known to actively refuse, or are never required e.g. tower staff)


Algorithms:
number_of_days = total number of sailing days
total_slots = total number of duty slots that need to be filled in period
ood_slots = total number of ood slots (should be number_of_days) 
licensed_crew_slots = total number of non-ood slots that need license (should be number_of_days x 2)
non_licensed_crew_slots = total number of non-ood slots that need license (should be number_of_days x 3)
dates = grab from google calendar

Algorithm 1:

1) 3 buckets - ood + licensed_crew + non_licensed_crew 
2) 3 pools - ood + licensed_crew + non_licensed_crew 
3) for each pool/bucket, in order (ood -> licensed_crew -> non_licensed_crew)
  i) Calculate  pool 
  ii) Fill bucket from pool, spreading out as much as possible
  iii) previously used people can still go into later pools, but take into account amount of work they have already performed

