public abstract class Validator
{
	public Validator(String[] args)
	{
	}

	public abstract ValidationResult validate(String[] outFile, String[] ansFile, String[] dataFile);
}
