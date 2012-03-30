import java.util.*;

public class FloatValidator extends Validator
{
	double eps;

	public FloatValidator(String[] args)
	{
		super(args);
		eps = Double.parseDouble(args[0]);
	}

	public boolean validateLine(String out, String ans)
	{
		String[] out_tokens = out.split("\\s+");
		String[] ans_tokens = ans.split("\\s+");

		if (out_tokens.length != ans_tokens.length)
			return false;

		for (int i = 0;i < out_tokens.length;i++)
		{
			Double o = null, a = null;

			try { o = Double.parseDouble(out_tokens[i]); }
			catch (Exception e) { }
			try { a = Double.parseDouble(ans_tokens[i]); }
			catch (Exception e) { }

			if ((o == null ? 1 : 0) + (a == null ? 1 : 0) == 1)
				return false;

			if (o == null && !out_tokens[i].equals(ans_tokens[i]))
				return false;
			if (o != null && Math.abs(o - a) > eps * Math.max(1, Math.abs(a)))
				return false;
		}
		return true;
	}

	public ValidationResult validate(String[] inputFile, String[] outputFile, String[] answerFile)
	{
		List<String> out = Arrays.asList(outputFile);
		List<String> ans = Arrays.asList(answerFile);

		if (out.size() != ans.size())
			return new ValidationResult("No - Wrong Answer",
			"Output contains " + out.size() + " line(s). Answer contains " + ans.size() + " line(s).");

		List<Integer> mismatch = new ArrayList<Integer>();
		for (int i = 0;i < out.size();i++)
			if (!validateLine(out.get(i), ans.get(i)))
				mismatch.add(i);

		if (mismatch.size() == 0)
			return new ValidationResult("Yes", "Correct.");

		String res = "" + mismatch.size() + " line(s) differ- first few lines: ";
		for (int i = 0;i < mismatch.size() && i < 5;i++)
			res += "#" + (mismatch.get(i) + 1) + " ";

		return new ValidationResult("No - Wrong Answer", res);
	}
}
