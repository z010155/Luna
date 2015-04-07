package AsyncMySQL;

use strict;
use warnings;

use Method::Signatures;
use Mojo::mysql;

method new {
       my $obj = bless {}, $self;
       return $obj;
}

method createMysql($strHost, $strDatabase, $strUsername, $strPassword) {
       my $mysql = Mojo::mysql->new;
       $mysql->from_string("mysql://".$strUsername.":".$strPassword."@".$strHost."/".$strDatabase);
       $self->{mysql} = $mysql;
}

method execQuery($strSQL) {
       my $resState = $self->{mysql}->db->query($strSQL); 
       return $resState;
}

method fetchColumns($strSQL) {
       my $resState = $self->{mysql}->db->query($strSQL);
       my $arrResult = $resState->hash;
       if ($arrResult) {
           return $arrResult;
       }
}

method fetchAll($strSQL) {
       my $resState = $self->{mysql}->db->query($strSQL);
       my $arrResult = $resState->hashes;
       if ($arrResult) {
           return $arrResult;
       }
}

method countRows($strSQL) {
       my $resState = $self->{mysql}->db->query($strSQL);
       my $arrResult = $resState->array;
       my $intCount = scalar(@{$arrResult});
       return $intCount;
}

method updateTable($strTable, $strSet, $mixSetVal, $strWhere, $mixWhereVal) {
       return if (!$strTable && !$strSet && !$mixSetVal && !$strWhere && !$mixWhereVal);
       my $resState = $self->{mysql}->db->query("update $strTable set $strSet = $mixSetVal where $strWhere = $mixWhereVal");
       return $resState;
}

method insertData($strTable, \@arrColumns, \@arrValues) {
       return if (!$strTable && !scalar(@arrColumns) && !scalar(@arrValues));
       my $strFields = join(', ', @arrColumns);
       my $resState = $self->{mysql}->db->query("insert into $strTable ($strFields) values (" . join(', ', ('?') x @arrColumns) . ")", @arrValues);
       return $resState->last_insert_id;
}

method deleteData($strTable, $strWhere, $mixWhereVal, $blnAnd = 0, $strAnd = '', $mixAndVal = '') {
       return if (!$strTable && !$strWhere && !$mixWhereVal);
       return $blnAnd ? $self->{mysql}->db->query("delete from $strTable where $strWhere = $mixWhereVal and $strAnd = $mixAndVal") : $self->{mysql}->db->query("delete from $strTable where $strWhere = $mixWhereVal");
}

1;
