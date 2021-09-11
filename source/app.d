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

Decimal binomial_pmf(Decimal n,Decimal k,Decimal p)
{
 return binomial(n,k)*p^^k*(Decimal(1)-p)^^(n-k);
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
  writeln(passed," tests passed.");
  writeln(failed," tests failed.");
}
