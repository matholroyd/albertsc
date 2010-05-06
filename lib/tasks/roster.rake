namespace :roster do
  task :test do
    dates = (1..30).collect {|i| i.days.from_now.to_date}
    
    rs = RosterScheduler.new
    roster = rs.plan_roster(dates, :ood_slots => 1, :licensed_crew_slots => 2, :unlicensed_crew_slots => 2)

    puts "Roster is..."
    roster.roster_days.each do |rd|
      puts " - Roster day => #{rd.date}"
      rd.roster_slots.each do |rs|
        puts "    (#{rs.require_qualified_for_ood ? 'OOD' : '   '}, #{rs.require_powerboat_licence ? 'lic' : '   '}) #{rs.member.name}"
      end
    end
  end
end