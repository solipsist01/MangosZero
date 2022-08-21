<?php
/****************************************************************************/
/*  					< MangosWeb Enhanced v3 >  							*/
/*              Copyright (C) <2009 - 2011>  <Wilson212>                    */
/*						  < http://keyswow.com >							*/
/*																			*/
/*			Original MangosWeb (C) 2007, Sasha, Nafe, TGM, Peec				*/
/****************************************************************************/

class Database
{

	// Queries statistics.
    var $_statistics = array(
        'time'  => 0,
        'count' => 0,
    );
    private $mysql;

/************************************************************
* Creates the connection to the mysql database, selects the posted DB
* Returns 0 if unable to connect to the database
* Returns 2 if the Database does not exist
* Returns TRUE on success
*/

    public function __construct($db_host, $db_port, $db_user, $db_pass, $db_name)
    {
        $this->mysql = @mysqli_connect($db_host.":".$db_port, $db_user, $db_pass);
        $this->selected_database = @mysqli_select_db($this->mysql, $db_name);
		return TRUE;
    }

//	************************************************************
// Closes the mysql DB connection

    public function __destruct()
    {
        @mysqli_close($this->mysql) or die(mysqli_error($this->mysql));
    }
	
/************************************************************
* Checks the connection to the mysql database, selects the posted DB
* Returns 0 if unable to connect to the database
* Returns 2 if the Database does not exist
* Returns TRUE on success
*/	
	public function status()
	{
		if(!$this->mysql)
		{
			return 0;
		}
		if(!$this->selected_database)
		{
			return 2;
		}
		return 1;
	}

//	************************************************************
// Query function is best used for INSERT and UPDATE functions

    public function query($query)
    {
        $sql = mysqli_query($this->mysql, $query) or die("Couldnt Run Query: ".$query."<br />Error: ".mysqli_error($this->mysql)."");
		$this->_statistics['count']++;
		return TRUE;
    }

//	************************************************************
// Select function is great for getting huge arrays of multiple rows and tables

    public function select($query)
    {
        $sql = mysqli_query($this->mysql, $query) or die("Couldnt Run Query: ".$query."<br />Error: ".mysqli_error($this->mysql)."");
		$this->_statistics['count']++;
		$i = 1;
		if(mysqli_num_rows($sql) == 0)
		{
			$result = FALSE;
		}
		else
		{
			while($row = mysqli_fetch_assoc($sql))
			{
				foreach($row as $colname => $value)
				{
					$result[$i][$colname] = $value;
				}
				$i++;
			}
		}
		return $result;
    }

//	************************************************************	
// selectRow is perfect for getting 1 row of data. Technically can be used for multiple rows,
// though select function is better for more then 1 row

	public function selectRow($query)
    {
        $sql = mysqli_query($this->mysql, $query) or die("Couldnt Run Query: ".$query."<br />Error: ".mysqli_error($this->mysql)."");
		$this->_statistics['count']++;
		if(mysqli_num_rows($sql) == 0)
		{
			return FALSE;
		}
		else
		{
			$row = mysqli_fetch_array($sql);
			return $row;
		}
    }
	
//	************************************************************
// selectCell returns 1 cell of data, Not recomended unless you want data from a specific cell in a table

	public function selectCell($query)
    {
        $sql = mysqli_query($this->mysql, $query) or die("Couldnt Run Query: ".$query."<br />Error: ".mysqli_error($this->mysql)."");
		$this->_statistics['count']++;
		if(mysqli_num_rows($sql) == 0)
		{
			return FALSE;
		}
		else
		{
			$row = mysqli_fetch_array($sql);
			return $row['0'];
		}
    }

//	************************************************************	
// count is a perfect function for counting the num of rows, or results in a table
// returns the direct count, for ex: 5

	public function count($query)
    {
        $sql = mysqli_query($this->mysql, $query) or die("Couldnt Run Query: ".$query."<br />Error: ".mysqli_error($this->mysql)."");
		$this->_statistics['count']++;
		return mysqli_fetch_row($sql)[0];
    }

//	************************************************************	
// Run a sql file function. Not written by me.
// $file is the path location to the sql file

	function runSQL($file)
	{
		$handle = @fopen($file, "r");
		if ($handle) 
		{
			while(!feof($handle)) 
			{
				$sql_line[] = fgets($handle);
			}
			fclose($handle);
		}
		else 
		{
			return FALSE;
		}
		foreach ($sql_line as $key => $query) 
		{
			if (trim($query) == "" || strpos ($query, "--") === 0 || strpos ($query, "#") === 0) 
			{
				unset($sql_line[$key]);
			}
		}
		unset($key, $query);

		foreach ($sql_line as $key => $query) 
		{
			$query = rtrim($query);
			$compare = rtrim($query, ";");
			if ($compare != $query) 
			{
				$sql_line[$key] = $compare . "|br3ak|";
			}
		}
		unset($key, $query);

		$sql_lines = implode($sql_line);
		$sql_line = explode("|br3ak|", $sql_lines);
		
		foreach($sql_line as $query)
		{
			if($query)
			{
				mysqli_query($this->mysql, $query) or die("Couldnt Run Query: ".$query."<br />Error: ".mysqli_error($this->mysql)."");
			}
		}
		return TRUE;
	}

    public function getConn() {
        return $this->mysql;
    }
}
?>
