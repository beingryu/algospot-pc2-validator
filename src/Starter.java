import java.lang.*;
import java.lang.reflect.*;
import java.io.*;
import java.util.*;

public class Starter
{
	public static String[] readLines(String fileName) throws Exception
	{
		ArrayList<String> lines = new ArrayList<String>();
		BufferedReader reader = new BufferedReader(new FileReader(fileName));
		for (;;)
		{
			String line = reader.readLine();
			if (line == null)
				break;
			lines.add(line);
		}
		reader.close();
		return lines.toArray(new String[lines.size()]);
	}

	public static void main(String[] args) throws Exception
	{
		// args[0]: input
		// args[1]: output
		// args[2]: answer
		// args[3]: result
		// args[4]: preprocess arguments
		// args[5]: validator to use
		// args[6..-1]: argument to validator
		String inputFileName = args[0];
		String outputFileName = args[1];
		String answerFileName = args[2];
		String resultFileName = args[3];
		String preprocessArgument = args[4];
		String validatorToUse;
		String[] argumentsToValidator;

		if (args.length == 5)
		{
			validatorToUse = "SimpleValidator";
			argumentsToValidator = new String[0];
		}
		else
		{
			validatorToUse = args[5];
			argumentsToValidator = Arrays.copyOfRange(args, 6, args.length);
		}

		Preprocessor p = new Preprocessor(preprocessArgument);
		String[] inputFile = readLines(inputFileName);
		String[] outputFile = p.preprocess(readLines(outputFileName));
		String[] answerFile = p.preprocess(readLines(answerFileName));

		Class<?> c = Class.forName(validatorToUse);

		Constructor<?> ctor = c.getConstructor(String[].class);
		Validator validator = (Validator)ctor.newInstance((Object)argumentsToValidator);

		ValidationResult res = validator.validate(inputFile, outputFile, answerFile);

		BufferedWriter w = new BufferedWriter(new FileWriter(resultFileName));
		w.write(res.toPC2Result(resultFileName));
		w.close();
	}
}
