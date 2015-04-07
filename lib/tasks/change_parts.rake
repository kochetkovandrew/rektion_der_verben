task :change_parts => :environment do
  VerbsRektion.all.each do |vr|
    newpart = vr.subpart
    if vr.part == 2
      newpart += 6
    end
    vr.part = newpart
    vr.save
  end
end
