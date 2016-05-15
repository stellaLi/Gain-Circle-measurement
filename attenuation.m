function [atten] = attenuation(freq)
    
        if freq < 550 && freq >= 500
            atten = 0.00128*freq + 0.365;
        elseif freq < 600 && freq >= 550
            atten = 0.00072*freq + 0.673;
        elseif freq < 650 && freq >= 600
            atten = -0.00096*freq + 1.681;
        elseif freq < 700 && freq >= 650
            atten = -0.00114*freq + 1.798;
        elseif freq < 750 && freq >=700
            atten = -0.00062*freq + 1.434;
        elseif freq < 800 && freq >=750
            atten = 0.00024*freq + 0.789;
        elseif freq < 850 && freq >=800
            atten = 0.0015*freq - 0.219;
        else
            atten = 0.00086*freq + 0.325;
        end
end


