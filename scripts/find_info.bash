BEGIN{
}
{
	if ($3=="wrap") {
		print "Slurm file: slurm-"+$1+".out"
		print $8
	}
}
END{
}
