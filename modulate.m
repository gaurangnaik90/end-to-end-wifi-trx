function symbols = modulate (bits, modulation)

if (strcmp(modulation,'bpsk'))
    symbols = 2 * bits - 1;
elseif (strcmp(modulation,'qpsk'))
        if (mod(length(bits),2))
            bits = [bits 0];
        end
        symbols = zeros (1,length(bits)/2);
        for i = 1:2:length(bits)
            b1 = bits(i);
            b2 = bits(i+1);
            if (b1 == 0 && b2 == 0)
                symbols((i-1)/2+1) = 1 + 1i;
            else if (b1 == 0 && b2 == 1)
                    symbols((i-1)/2+1) = -1 + 1i;
                else if (b1 == 1 && b2 == 1)
                        symbols((i-1)/2+1) = -1 - 1i;
                    else if (b1 == 1 && b2 == 0)
                            symbols((i-1)/2+1) = 1 - 1i;
                        end
                    end
                end
            end
        end
elseif (strcmp(modulation,'8psk'))
        if (mod(length(bits),3) == 1)
            bits = [bits 0 0];
        else if (mod(length(bits),3) == 2)
                bits = [bits 0];
            end
        end
        symbols = zeros (1, length(bits)/3);
        for i=1:3:length(bits)
            b1 = bits(i);
            b2 = bits(i+1);
            b3 = bits(i+2);
            if (b1 == 0 && b2 == 0 && b3 == 0)
                symbols((i-1)/3+1) = 1 + 1i * 0;
            else if (b1 == 0 && b2 == 0 && b3 == 1)
                    symbols((i-1)/3+1) = 1/sqrt(2) + 1i * 1/sqrt(2);
                else if (b1 == 0 && b2 == 1 && b3 == 1)
                        symbols((i-1)/3+1) = 0 + 1i;
                    else if (b1 == 0 && b2 == 1 && b3 == 0)
                            symbols((i-1)/3+1) = -1/sqrt(2) + 1i * 1/sqrt(2);
                        else if (b1 == 1 && b2 == 1 && b3 == 0)
                                symbols((i-1)/3+1) = -1 + 1i * 0;
                            else if (b1 == 1 && b2 == 1 && b3 == 1)
                                    symbols((i-1)/3+1) = -1/sqrt(2) - 1i * 1/sqrt(2);
                                else if (b1 == 1 && b2 == 0 && b3 == 1)
                                        symbols((i-1)/3+1) = 0 - 1i;
                                    else if (b1 == 1 && b2 == 0 && b3 == 0)
                                            symbols((i-1)/3+1) = 1/sqrt(2) - 1i * 1/sqrt(2);
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
elseif (strcmp(modulation,'16qam'))
        if (mod(length(bits),4) == 1)
            bits = [bits 0 0 0];
        else if (mod(length(bits),4) == 2)
                bits = [bits 0 0];
            else if (mod(length(bits),4) == 3)
                    bits = [bits 0];
                end
            end
        end
        symbols = zeros (1,length(bits)/4);
        for i = 1:4:length(bits)
            d = bi2de ([bits(i) bits(i+1) bits(i+2) bits(i+3)],'left-msb');
            if (d == 0)
                symbols((i-1)/4+1) = -3 + 1i * 3;
            else if (d == 1)
                    symbols((i-1)/4+1) = -3 + 1i * 1;
                else if (d == 3)
                        symbols((i-1)/4+1) = -3 - 1i * 1;
                    else if (d == 2)
                            symbols((i-1)/4+1) = -3 - 1i * 3;
                        else if (d == 6)
                                symbols((i-1)/4+1) = -1 - 1i * 3;
                            else if (d == 7)
                                    symbols((i-1)/4+1) = -1 - 1i * 1;
                                else if (d == 5)
                                        symbols((i-1)/4+1) = -1 + 1i * 1;
                                    else if (d == 4)
                                            symbols((i-1)/4+1) = -1 + 1i * 3;
                                        else if (d == 12)
                                                symbols((i-1)/4+1) = 1 + 1i * 3;
                                            else if (d == 13)
                                                    symbols((i-1)/4+1) = 1 + 1i * 1;
                                                else if (d == 15)
                                                        symbols((i-1)/4+1) = 1 - 1i * 1;
                                                    else if (d == 14)
                                                            symbols((i-1)/4+1) = 1 - 1i * 3;
                                                        else if (d == 10)
                                                                symbols((i-1)/4+1) = 3 - 1i * 3;
                                                            else if (d == 11)
                                                                    symbols((i-1)/4+1) = 3 - 1i * 1;
                                                                else if (d == 9)
                                                                        symbols((i-1)/4+1) = 3 + 1i * 1;
                                                                    else if (d == 8)
                                                                            symbols((i-1)/4+1) = 3 + 1i * 3;
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end                    
end
symbols = symbols / sqrt(mean(abs(symbols).^2)); % Normalize to unit power
end
