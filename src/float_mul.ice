$$if MUL_FLOAT == nil then
$$MUL_FLOAT = 1

algorithm mul_float(
    input uint$float_size$ f1,
    input uint$float_size$ f2, 
    output uint$float_size$ res)
{
    uint$exponant_size$ e1          := f1[$mantissa_size$, $exponant_size$];
    uint$exponant_size$ e2          := f2[$mantissa_size$, $exponant_size$];
    uint$mantissa_size +1$ m1       := {1b1, f1[0, $mantissa_size$]};
    uint$mantissa_size +1$ m2       := {1b1, f2[0, $mantissa_size$]};
    uint$exponant_size$ one_inv     := {1b1, $exponant_size-1$b0};
    uint$exponant_size$ bias        := ~{1b1, $exponant_size-1$b0};
    uint1 r_s                       := f1[$float_size-1$,1] == f2[$float_size-1$,1] ? f2[$float_size-1$,1] : -1;
    uint$mantissa_size$ r_m(0);
    uint$exponant_size$ r_e(0);
    

    //mantissa multiplication
    uint$(mantissa_size +1)*2$ tmp(0);
    uint$(mantissa_size +1)*2$ r_0 := m2[0,1] ? m1 : 0;
$$for i=1,mantissa_size do
        uint$(mantissa_size +1)*2$ r_$i$ := m2[$i$,1] ? {m1,$i$b0} : 0;
$$end
//    __display("m1 : %b", m1);
//    __display("m2 : %b", m2);
    tmp = 
$$for i=0,mantissa_size-1 do
        r_$i$+
$$end
        r_$mantissa_size$;

//    __display("tmp : %b", tmp);
    
    r_m = tmp[$mantissa_size*2 +1$,1] ? tmp[$mantissa_size+1$, $mantissa_size$] : tmp[$mantissa_size$, $mantissa_size$];

    //TODO fix for neg exponent
    if((e1[$exponant_size-1$,1] && e2[$exponant_size-1$,1]) | ~e1 == one_inv | ~e2 == one_inv){
        r_e = tmp[$mantissa_size*2 +1$,1] ? e1  + (e2[0,$exponant_size-1$]+ 1) +1 : e1  + (e2[0,$exponant_size-1$]+ 1);
    }
    else{
        if(e1[$exponant_size-1$,1] && ~e2[$exponant_size-1$,1]){
            r_e = tmp[$mantissa_size*2 +1$,1] ? e1 - (bias-e2) +1:  e1 - (bias-e2) ;
        }
        else{
            if(~e1[$exponant_size-1$,1] && e2[$exponant_size-1$,1]){
                r_e = tmp[$mantissa_size*2 +1$,1] ? e2 - (bias-e1) +1 :  e2 - (bias-e1);
            }
            else{ /*~e1[$exponant_size-1$] && ~e2[$exponant_size-1$]*/                
                r_e =  tmp[$mantissa_size*2 +1$,1] ? e2+e1 - bias +1 : e2+e1 - bias;
            }
        }
    }
    
    res = {r_s,r_e,r_m};
}

$$end