
import java.util.*;

public class Preprocessor
{
	public boolean left; // Strip left(leading) whitespaces
	public boolean right; // Strip right(trailing) whitespaces
	public boolean all; // Strip all whitespaces
	public boolean last; // Strip last empty line
	public boolean empty; // Strip empty lines
	public boolean ignore; // Ignore cases

	public Preprocessor(String args)
	{
		left = args.contains("l");
		right = args.contains("r");
		all = args.contains("a");
		last = args.contains("z");
		empty = args.contains("e");
		ignore = args.contains("i");
	}

	public List<String> stripLeft(List<String> src)
	{
		List<String> res = new ArrayList<String>();
		for (String x : src)
			res.add(x.replaceAll("^\\s+", ""));
		return res;
	}

	public List<String> stripRight(List<String> src)
	{
		List<String> res = new ArrayList<String>();
		for (String x : src)
			res.add(x.replaceAll("\\s+$", ""));
		return res;
	}

	public List<String> stripAll(List<String> src)
	{
		List<String> res = new ArrayList<String>();
		for (String x : src)
			res.add(x.replaceAll("\\s+", ""));
		return res;
	}

	public List<String> stripLast(List<String> src)
	{
		List<String> res = new ArrayList<String>();
		String last = null;
		for (String x : src)
		{
			if (last != null) res.add(last);
			last = x;
		}
		if (last.length() != 0)
			res.add(last);
		return res;
	}

	public List<String> stripEmpty(List<String> src)
	{
		List<String> res = new ArrayList<String>();
		for (String x : src)
			if (x.length() != 0) res.add(x);
		return res;
	}

	public List<String> downcase(List<String> src)
	{
		List<String> res = new ArrayList<String>();
		for (String x : src)
			res.add(x.toLowerCase());
		return res;
	}

	public String[] preprocess(String[] src)
	{
		List<String> x = Arrays.asList(src);

		if (left) x = stripLeft(x);
		if (right) x = stripRight(x);
		if (all) x = stripAll(x);
		if (last) x = stripLast(x);
		if (empty) x = stripEmpty(x);
		if (ignore) x = downcase(x);

		return x.toArray(new String[x.size()]);
	}
}
