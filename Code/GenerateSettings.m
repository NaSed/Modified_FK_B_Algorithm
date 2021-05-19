function setting = GenerateSettings()
Hashing = {true, false};
Canonical = {true, false};
Shrinkage = {true, false};
Ordering = {true, false};
recentHist = {true, false};
setting = [];
for h=1:2 %hash
    for c=1:2
        if (h==1) || (h==2 && c==2)
            for s=1:2
                for o=1:2
                    if o==1
                        setting = [setting; Hashing{h}, Canonical{c}, Shrinkage{s}, Ordering{o}, recentHist{1}];
                        setting = [setting; Hashing{h}, Canonical{c}, Shrinkage{s}, Ordering{o}, recentHist{2}];
                    else
                        setting = [setting; Hashing{h}, Canonical{c}, Shrinkage{s}, Ordering{o}, recentHist{2}];
                    end
                end
            end
        end
    end
end
setting = setting ==1;
end
