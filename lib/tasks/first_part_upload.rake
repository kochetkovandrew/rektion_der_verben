task :first_part_upload => :environment do
  f = File.open Rails.root.join 'doc', 'rektion1.txt'
  n = 0
  rec = {}
  while s=f.gets do
    s.chomp! "\n"
    if !/^$/.match s
      n+=1
      if n==1
        rec[:verb] = s
      elsif n==2
        rec[:preposition] = s
      elsif n==3
        rec[:case] = s
      else
        v = VerbsRektion.new
        v.verb = rec[:verb]
        v.preposition = rec[:preposition]
        v.case = rec[:case]
        v.translation = s
        v.part = 1
        v.save
        n = 0
      end
    end
  end
end
