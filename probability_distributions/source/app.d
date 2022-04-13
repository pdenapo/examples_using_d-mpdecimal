import std.stdio;
import d_mpdecimal.decimal;

Decimal factorial(Decimal n)
{
  Decimal uno=1;
  if (n.iszero())
    return uno;
  Decimal f=uno;
  while (n> uno)
  {
    f=f*n;
    n--;
  }
  return f;
}

Decimal variaciones(Decimal n,Decimal k)
{
  Decimal uno=1;
  if (k.iszero())
    return uno;
  Decimal f=n;
  while (k> uno)
  {
    n--;
    f=f*n;
    k--;
  }
  return f;
}

Decimal binomial(Decimal n,Decimal k)
{
 return variaciones(n,k)/factorial(k);
}

struct binomial_distribution{
  Decimal n;
  Decimal p;

  //  Probability mass function
  Decimal pmf(Decimal k)
 {
   Decimal zero= Decimal(0);
   if (!k.isinteger)
      return zero;
   else if (k.isnegative)
      return zero; 
   else if (k>n)
      return zero;       
   else
      return binomial(n,k)*p^^k*(Decimal(1)-p)^^(n-k);
 }

   // Cumulative distribution function.
   Decimal cdf(Decimal x)
   {
     Decimal result= Decimal(0);
     if (x.isnegative)
        return result;
      Decimal k=Decimal(0);
      while(k<=x)
      {
        result += pmf(k);
        k++;
      }
      return result;
   }

   Decimal mean()
   {
     return n*p;
   }
}

struct Poisson_distribution{
  Decimal lambda;

  //  Probability mass function
  Decimal pmf(Decimal k)
 {
   Decimal zero= Decimal(0);
   if (!k.isinteger)
      return zero;
   else if (k.isnegative)
      return zero; 
   else 
      return lambda^^k*decimal_exp(-lambda)/factorial(k);
 }

   // Cumulative distribution function.
   Decimal cdf(Decimal x)
   {
     Decimal result= Decimal(0);
     if (x.isnegative)
        return result;
      Decimal k=Decimal(0);
      while(k<=x)
      {
        result += pmf(k);
        k++;
      }
      return result;
   }

   Decimal mean()
   {
     return lambda;
   }
}


int passed;
int failed;


void perform_test(string name, Decimal computed,string expected)
{
  writeln(computed);
  bool result = computed.toString()== expected;
  if (result)
  {
    writeln("Test ",name, " passed");
    passed++;
  }
  else
  {
    writeln("Test ",name, " failed");
    failed++; 
  }
}


void perform_test_with_format(string name,Decimal computed,string fmt,string expected)
{
  writeln(computed);
  string s=computed.format(fmt);
  writeln(s);
  bool result = s== expected;
  if (result)
  {
    writeln("Test ",name, " passed");
    passed++;
  }
  else
  {
    writeln("Test ",name, " failed");
    failed++; 
  }
}


void main()
{
  init_decimal(100);
  perform_test("0! ",factorial(Decimal(0)),"1");
  perform_test("1! ",factorial(Decimal(1)),"1");
  perform_test("2! ",factorial(Decimal(2)),"2");
  perform_test("3! ",factorial(Decimal(3)),"6");
  perform_test("6! ",factorial(Decimal(6)),"720");
  perform_test("var(6,1) ",variaciones(Decimal(6),Decimal(1)),"6");
  perform_test("var(6,2) ",variaciones(Decimal(6),Decimal(2)),"30");
  perform_test("var(6,3) ",variaciones(Decimal(6),Decimal(3)),"120");
  perform_test("binomial(4,0) ",binomial(Decimal(4),Decimal(0)),"1");
  perform_test("binomial(4,1) ",binomial(Decimal(4),Decimal(1)),"4");
  perform_test("binomial(4,2) ",binomial(Decimal(4),Decimal(2)),"6");
  perform_test("binomial(4,3) ",binomial(Decimal(4),Decimal(1)),"4");
  perform_test("binomial(4,4) ",binomial(Decimal(4),Decimal(4)),"1");
  perform_test("binomial(4,4) ",binomial(Decimal(4),Decimal(4)),"1");
  // probabilidad de obtener dos caras en 6 tiradas de una moneda=15/64
  auto bd= binomial_distribution(Decimal(6),Decimal("0.5"));
  perform_test("binomial_pmf(6,0.5).pmf(2) ",bd.pmf(Decimal(2)),"0.234375");
  // probabilidad de obtener a lo sumo 3 caras en 6 tiradas de una moneda
  perform_test("binomial_pmf(6,0.5).cdf(3) ",bd.cdf(Decimal(3)),"0.656250");

  writeln("Ejemplos de mi clase");
  auto bd2= binomial_distribution(Decimal(10),Decimal("0.5"));
  perform_test("Ejemplo 1: exacto ",bd2.pmf(Decimal(3)),"0.1171875000");
  auto mu= bd2.mean();
  auto approx_Poisson= Poisson_distribution(mu);
  perform_test_with_format("Ejemplo 1: Aprox. de Poisson ",approx_Poisson.pmf(Decimal(3)),"0.7f","0.1403739");
  writeln(passed," tests passed.");
  writeln(failed," tests failed.");
}
