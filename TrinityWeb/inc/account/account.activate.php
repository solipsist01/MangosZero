<?php
//========================//
if(INCLUDED !== TRUE) 
{
	echo "Not Included!"; 
	exit;
}
$pathway_info[] = array('title' => $lang['activation'], 'link' => '');
// ==================== //

// Tell the cache system not to cache this page
define('CACHE_FILE', FALSE);

if(isset($_POST['key']) && isset($_POST['user']))
{
	$sub_id = $DB->selectCell("SELECT `id` FROM `account` WHERE `username` LIKE '".$_POST['user']."'");
	if($sub_id != FALSE)
	{
		redirect("?p=account&sub=activate&id=".$sub_id."&key=".$_POST['key']."", 1);
	}
	else
	{
		output_message('error', 'Invalid username');
	}
}

function CheckKey()
{
	global $user, $DB, $Account;
	if(isset($_GET['key']))
	{
		if(isset($_GET['id']))
		{
			$lock = $DB->selectCell("SELECT `locked` FROM account WHERE id='".$_GET['id']."'");
			if($user['id'] > 0 && $lock == 0)
			{
				output_message('info', 'Your account is already active!');
			}
			else
			{
				$check_key = $Account->isValidActivationKey($_GET['key']);
				if($check_key != FALSE)
				{
					if($_GET['id'] == $check_key)
					{
						$DB->query("UPDATE account SET locked=0 WHERE id='".$_GET['id']."' LIMIT 1");
						$DB->query("UPDATE account_extend SET activation_code=NULL WHERE account_id='".$_GET['id']."' LIMIT 1");
						output_message('success', '<b>Account successfully activated! You may now log into the server and play.</b>');
					}
					else
					{
						output_message('error', 'This Activation Key does not belong to this account id!');
					}
				}
				else
				{
					output_message('error', 'Not a valid activation key.');
				}
			}
		}
	}
}

?>
