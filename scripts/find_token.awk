BEGIN{
is_found=0;
node=0;
port=0;
token_str="";
}
{
	if (is_found==1){
		is_found=0;
		token_str=$1
		port=substr($1,18,4)
	}
	if ($1=="Or"){
		is_found=1;
	}
	if ($1=="SLURM_JOB_NODELIST"){
		node=$3
	}
}
END{
	print token_str
	new_str = sprintf("ssh -NL localhost:%d:localhost:%d -J miptstudent studtscm03@%s", port, port, node)
	print new_str
}

