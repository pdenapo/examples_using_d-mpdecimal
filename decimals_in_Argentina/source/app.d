import std.stdio;
import d_mpdecimal.decimal;

int passed;
int failed;

string decimal_ar(Decimal x)
{
  string formato = "0.2f";
  Decimal x_abs = decimal_abs(x);
  string x_str = x_abs.format(formato);
  int i = 0;
  while (x_str[i] != '.')
    i++;
  string parte_entera = x_str[0 .. i];
  string parte_decimal = x_str[i + 1 .. $];
  ulong longitud_parte_entera = parte_entera.length;
  string parte_entera_con_comas = "";
  foreach (j, c; parte_entera)
  {
    parte_entera_con_comas ~= c;
    if (c == '-')
      break;
    ulong columna = longitud_parte_entera - j - 1;
    if (columna > 0 && columna % 3 == 0)
      parte_entera_con_comas ~= '.';
  }
  if (x.isnegative())
    parte_entera_con_comas = '-' ~ parte_entera_con_comas;
  return parte_entera_con_comas ~ "," ~ parte_decimal;
}

void perform_test(string input, string expected)
{
  Decimal x = Decimal(input);
  string computed = decimal_ar(x);
  writeln(computed);
  bool result = computed == expected;
  if (result)
  {
    writeln("Test ", input, " passed");
    passed++;
  }
  else
  {
    writeln("Test ", input, " failed");
    failed++;
  }
}

void main()
{
  init_decimal(100);
  perform_test("10.25", "10,25");
  perform_test("10.009", "10,01"); // rounded!
  perform_test("-10.25", "-10,25");
  perform_test("-10.009", "-10,01"); // rounded!
  perform_test("1230.25", "1.230,25");
  perform_test("41230.25", "41.230,25");
  perform_test("541230.25", "541.230,25");
  perform_test("6541230.25", "6.541.230,25");
  perform_test("-1230.25", "-1.230,25");
  perform_test("-41230.25", "-41.230,25");
  perform_test("-541230.25", "-541.230,25");
  perform_test("8541230.25", "8.541.230,25");
  perform_test("-8541230.25", "-8.541.230,25");

  writeln(passed, " tests passed.");
  writeln(failed, " tests failed.");
}
