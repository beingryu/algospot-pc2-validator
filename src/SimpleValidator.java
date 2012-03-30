import java.util.*;

public class SimpleValidator extends Validator
{
	public SimpleValidator(String[] args)
	{
		super(args);
	}

	public ValidationResult validate(String[] inputFile, String[] outputFile, String[] answerFile)
	{
		List<String> out = Arrays.asList(outputFile);
		List<String> ans = Arrays.asList(answerFile);

		if (out.equals(ans))
			return new ValidationResult("Yes", "Correct.");

		if (out.size() != ans.size())
			return new ValidationResult("No - Wrong Answer",
			"Output contains " + out.size() + " line(s). Answer contains " + ans.size() + " line(s).");

		List<Integer> mismatch = new ArrayList<Integer>();
		for (int i = 0;i < out.size();i++)
			if (!out.get(i).equals(ans.get(i)))
				mismatch.add(i);

		String res = "" + mismatch.size() + " line(s) differ- first few lines: ";
		for (int i = 0;i < mismatch.size() && i < 5;i++)
			res += "#" + (mismatch.get(i) + 1) + " ";

		return new ValidationResult("No - Wrong Answer", res);
	}
}
