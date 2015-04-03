package CPUser;

use strict;
use warnings;

use Method::Signatures;
use HTTP::Date qw(str2time);
use Math::Round qw(round);
use HTML::Entities;
use Switch;

method new($resParent, $resSock) {
       my $obj = bless {}, $self;
       $obj->{parent} = $resParent;
       $obj->{sock} = $resSock;
       $obj->{username} = '';            
       $obj->{ID} = 0;
       $obj->{ipAddr} = '';
       $obj->{loginKey} = '';
       $obj->{coins} = 0;
       $obj->{rank} = 1;
       $obj->{age} = 0;
       $obj->{active} = 0;
       $obj->{isMuted} = 0;
       $obj->{isBanned} = 0;
       $obj->{isStaff} = 0;
       $obj->{isAdmin} = 0;
       $obj->{isAuth} = 0;
       $obj->{bitMask} = 1;
       $obj->{banCount} = 0;
       $obj->{invalidLogins} = 0;
       $obj->{colour} = 0;
       $obj->{head} = 0;
       $obj->{face} = 0;
       $obj->{neck} = 0;
       $obj->{body} = 0;
       $obj->{hand} = 0;
       $obj->{feet} = 0;
       $obj->{flag} = 0;
       $obj->{photo} = 0;
       $obj->{isEPF} = 0;
       $obj->{epfPoints} = 0;
       $obj->{totalEPFPoints} = 0;
       $obj->{fieldOPStatus} = 0;
       $obj->{room} = 0;
       $obj->{frame} = 0;
       $obj->{xpos} = 100;
       $obj->{ypos} = 100;
       $obj->{igloo} = 0;
       $obj->{floor} = 0;
       $obj->{music} = 0;
       $obj->{furniture} = '';
       $obj->{cover} = '';
       $obj->{buddies} = {};
       $obj->{ignored} = {};
       $obj->{inventory} = [];
       $obj->{ownedIgloos} = [];
       $obj->{stamps} = [];
       $obj->{restamps} = [];
       $obj->{ownedFurns} = {};
       $obj->{buddyRequests} = {};
       return $obj;
}

method sendXT(\@arrArgs) {
       my $strPacket = '%xt%';
       $strPacket .= join('%', @arrArgs) . '%';
       $self->write($strPacket);
}

method write($strData) {
       if ($self->{sock}->connected) {
           send($self->{sock}, $strData . chr(0), 0);
       }
       if ($self->{parent}->{servConfig}->{debugging}) {
           $self->{parent}->{modules}->{logger}->output('Packet Sent: ' . $strData, Logger::LEVELS->{dbg});        
       }
}

method sendRoom($strData) {
       foreach (values %{$self->{parent}->{clients}}) {
                if ($_->{room} == $self->{room}) {
                    $_->write($strData);
                }
       }
}

method loadDetails {
       my $arrInfo = $self->{parent}->{modules}->{mysql}->fetchColumns("SELECT * FROM users WHERE `ID` = '$self->{ID}'"); 
       while (my ($key, $value) = each(%{$arrInfo})) {
              switch ($key) {
                      case ('age') {
                            $self->{age} = round((time - str2time($value)) / 86400);
                      }
                      case ('buddies') {
                            my @buddies = split(',', $value);
                            foreach (@buddies) {
                                     my ($userID, $username) = split('\\|', $_);
                                     $self->{buddies}->{$userID} = $username;
                            }
                      }
                      case ('ignored') {
                            my @ignored = split(',', $value);
                            foreach (@ignored) {
                                     my ($userID, $username) = split('\\|', $_);
                                     $self->{ignored}->{$userID} = $username;
                            }
                      }
                      case ('inventory') {
                            my @items = split('%', $value);
                            foreach (@items) {
                                     push(@{$self->{inventory}}, $_);
                            }
                      }
                      case ('stamps') {
                            my @stamps = split('\\|', $value);
                            foreach (@stamps) {
                                     push(@{$self->{stamps}}, $_);
                            }
                      }
                      case ('restamps') {
                            my @restamps = split('\\|', $value);
                            foreach (@restamps) {
                                     push(@{$self->{restamps}}, $_);
                            }
                      } else {
                            $self->{$key} = $value;
                      }
              }
       }   
       my $arrIglooInfo = $self->{parent}->{modules}->{mysql}->fetchColumns("SELECT * FROM igloos WHERE `ID` = '$self->{ID}'"); 
       while (my ($key, $value) = each(%{$arrIglooInfo})) {
              switch ($key) {
                      case ('ownedIgloos') {
                            my @igloos = split('\\|', $value);
                            foreach (@igloos) {
                                     push(@{$self->{ownedIgloos}}, $_);
                            }
                      }
                      case ('ownedFurns') {
                            my @furnitures = split(',', $value);
                            foreach (@furnitures) {
                                     my ($furnID, $furnQuantity) = split('\\|', $_);
                                     $self->{ownedFurns}->{$furnID} = $furnQuantity;
                            }
                      } else {
                            $self->{$key} = $value;
                      }
              }
       }
}

method buildClientString {
       my @arrInfo = (
                   $self->{ID}, 
                   $self->{username},
                   $self->{bitMask},
                   $self->{colour}, 
                   $self->{head}, 
                   $self->{face}, 
                   $self->{neck}, 
                   $self->{body}, 
                   $self->{hand}, 
                   $self->{feet}, 
                   $self->{flag}, 
                   $self->{photo}, 
                   $self->{xpos}, 
                   $self->{ypos}, 
                   $self->{frame}, 1, 
                   $self->{rank} * 146,                
       );
       my $strInfo = join('|', @arrInfo);
       return $strInfo;
}

method buildBotString {
       my @arrInfo = (
                   'botID' => 0, 
                   'botName' => 'Mystic', 
                   'bitMask' => 1, 
                   'botColour' => 4, 
                   'botHead' => 1007, 
                   'botFace' => 106, 
                   'botNeck' => 0, 
                   'botBody' => 221, 
                   'botHand' => 0, 
                   'botFeet' => 0, 
                   'botFlag' => 0, 
                   'botPhoto' => 0, 
                   'xpos' => 0, 
                   'ypos' => 0, 
                   'frame' => 0, 
                   'isMember' => 1,
                   'rank' => 999
       );
       my $strInfo = join('|', values @arrInfo);
       return $strInfo;
}

method getClientByID($intPID) {
       return if (!int($intPID));
       foreach (values %{$self->{parent}->{clients}}) {
                if ($_->{ID} == $intPID) {
                    return $_;
                }
	      }
}

method getClientByName($strName) {
       return if (!$strName);
       foreach (values %{$self->{parent}->{clients}}) {
                if (lc($_->{username}) eq lc($strName)) {
                    return $_;
                }
	      }
}

method sendError($intError) {
       $self->write('%xt%e%-1%' . $intError . '%');
}

method updateCoins($intCoins) {
       return if (!int($intCoins));
       $self->sendXT(['zo', '-1', $intCoins]);
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'coins', $intCoins, 'ID', $self->{ID});
       $self->{coins} = $intCoins;
}

method setCoins($intCoins) {
       return if (!int($intCoins));
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'coins', $intCoins, 'ID', $self->{ID});
       $self->{coins} = $intCoins;
}

method updateIP($ipAddr) {
       return if (!$ipAddr);
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'ipAddr', $ipAddr, 'ID', $self->{ID});
}

method updateKey($strKey, $strName) {
       return if (!$strName);
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'loginKey', $strKey, 'username', $strName);
}

method updateInvalidLogins($intCount, $strName) {
       return if (!int($intCount) && !$strName);
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'invalidLogins', $intCount, 'username', $strName);
}

method updatePlayerCard($strData, $strType, $intItem) {
       return if (!$strData && !$strType && !int($intItem));
       $self->sendRoom('%xt%' . $strData . '%-1%' . $self->{ID} . '%' . $intItem . '%');
       $self->{parent}->{modules}->{mysql}->updateTable('users', $strType, $intItem, 'ID', $self->{ID});
       $self->{$strType} = $intItem;
}

method throwSnowball($intX, $intY) {
       return if (!int($intX) && !int($intY));
       $self->sendRoom('%xt%sb%-1%' . $self->{ID} . '%' . $intX . '%' . $intY . '%');
}

method sendJoke($intJoke) {
       return if (!int($intJoke));
       $self->sendRoom('%xt%sj%-1%' . $self->{ID} . '%' . $intJoke . '%');
}

method sendEmote($intEmote) {
       return if (!int($intEmote));
       $self->sendRoom('%xt%se%-1%' . $self->{ID} . '%' . $intEmote . '%');
}

method sendTourMsg($intMsg) {
       return if (!int($intMsg));
       $self->sendRoom('%xt%sg%-1%' . $self->{ID} . '%' . $intMsg . '%');
}

method sendSafeMsg($intMsg) {
       return if (!int($intMsg));
       $self->sendRoom('%xt%ss%-1%' . $self->{ID} . '%' . $intMsg . '%');    
}

method sendMascotMsg($intMsg) {
       return if (!int($intMsg));
       $self->sendRoom('%xt%sma%-1%' . $self->{ID} . '%' . $intMsg . '%');
}

method sendMessage($strMsg) {
       if (!$self->{isMuted} && $strMsg ne '') {
           $self->sendRoom('%xt%sm%-1%' .  $self->{ID} . '%' . decode_entities($strMsg) . '%');
       }
}

method getLatestRevision {
       $self->sendXT(['glr', '-1', 3555]);
}

method getPlayer($intPID) {
       return if (!int($intPID));
       my $dbInfo = $self->{parent}->{modules}->{mysql}->fetchColumns("SELECT `ID`, `nickname`, `bitMask`, `colour`, `face`, `body`, `feet`, `hand`, `neck`, `head`, `flag`, `photo`, `rank` FROM users WHERE `ID` = '$intPID'");
       my @arrDetails = ($dbInfo->{ID}, $dbInfo->{nickname}, $dbInfo->{bitMask}, $dbInfo->{colour}, $dbInfo->{head}, $dbInfo->{face}, $dbInfo->{neck}, $dbInfo->{body}, $dbInfo->{hand}, $dbInfo->{feet}, $dbInfo->{flag}, $dbInfo->{photo}, $dbInfo->{rank} * 146);
       $self->sendXT(['gp', '-1', $intPID, join('|', @arrDetails)]);
}

method sendHeartBeat {
       $self->sendXT(['h', '-1']);
}

method setPosition($intX, $intY) {
       return if (!int($intX) && !int($intY));
       $self->sendRoom('%xt%sp%-1%' . $self->{ID} . '%' . $intX . '%' . $intY . '%');
       $self->{xpos} = $intX;
       $self->{ypos} = $intY;
}

method setFrame($intFrame) {
       return if (!int($intFrame));
       $self->sendRoom('%xt%sf%-1%' . $self->{ID} . '%' . $intFrame . '%');
       $self->{frame} = $intFrame;
}

method setAction($intAction) {
       return if (!int($intAction));
       $self->sendRoom('%xt%sa%-1%' . $self->{ID} . '%' . $intAction . '%');
}

method removePlayer {
       return if (!int($self->{room}));
       $self->sendRoom('%xt%rp%-1%' . $self->{ID} . '%');
}

method joinRoom($intRoom, $intX = 330, $intY = 330) {
       return if (!int($intRoom) && !int($intX) && !int($intY));
       $self->removePlayer;
       if (exists($self->{parent}->{modules}->{crumbs}->{gameRoomCrumbs}->{$intRoom})) {
       	   $self->{room} = $intRoom;
           return $self->sendXT(['jg', '-1', $intRoom]);
       } elsif (exists($self->{parent}->{modules}->{crumbs}->{roomCrumbs}->{$intRoom}) || $intRoom > 1000) {
                $self->{room} = $intRoom;
                $self->{xpos} = $intX;
                $self->{ypos} = $intY;
                if ($intRoom <= 899 && $self->getRoomCount >= $self->{parent}->{modules}->{crumbs}->{roomCrumbs}->{$intRoom}->{limit}) {
                    return $self->sendError(210);
                }
                my $strData = '%xt%jr%-1%'  . $intRoom . '%' . $self->buildRoomString;  
                $self->write($strData);
                $self->sendRoom('%xt%ap%-1%' . $self->buildClientString . '%');
       }
}

method addItem($intItem) { 
       return if (!int($intItem));
       if (!exists($self->{parent}->{modules}->{crumbs}->{itemCrumbs}->{$intItem})) {
	          return $self->sendError(402);
       } elsif (grep /$intItem/, @{$self->{inventory}}) {
	          return $self->sendError(400);
       } elsif ($self->{coins} < $self->{parent}->{modules}->{crumbs}->{itemCrumbs}->{$intItem}->{cost}) {
	          return $self->sendError(401);
       }    
       push(@{$self->{inventory}}, $intItem);
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'inventory', join('%', @{$self->{inventory}}) , 'ID', $self->{ID});
       $self->setCoins($self->{coins} - $self->{parent}->{modules}->{crumbs}->{itemCrumbs}->{$intItem}->{cost});
       $self->sendXT(['ai', '-1', $intItem, $self->{coins}]);
}

method addStamp($intStamp) {
       return if (!int($intStamp));
       return if (!exists($self->{parent}->{modules}->{crumbs}->{stampCrumbs}->{$intStamp}));
       return if (grep /$intStamp/, @{$self->{stamps}});
       push(@{$self->{stamps}}, $intStamp);
       push(@{$self->{restamps}}, $intStamp);
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'stamps', join('|', @{$self->{stamps}}), 'ID', $self->{ID});
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'restamps', join('|', @{$self->{restamps}}), 'ID', $self->{ID});
       $self->sendXT(['aabs', '-1', $intStamp]);
}

method updateEPF($blnEpf) {
       return if (!int($blnEpf));
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'isEPF', $blnEpf, 'ID', $self->{ID});
       $self->{isEPF} = $blnEpf;
}

method handleBuddyOnline {
       foreach (keys %{$self->{buddies}}) {
                if ($self->getOnline($_)) {
                    my $objPlayer = $self->getClientByID($_);
                    $objPlayer->sendXT(['bon', '-1', $self->{ID}]);
                }
       }
}

method handleBuddyOffline {
       foreach (keys %{$self->{buddies}}) {
                if ($self->getOnline($_)) {
                    my $objPlayer = $self->getClientByID($_);
                    $objPlayer->sendXT(['bof', '-1', $self->{ID}]);
                }
       }
}

method updateOPStat($blnStat) {
       return if (!int($blnStat));
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'fieldOPStatus', $blnStat, 'ID', $self->{ID});
       $self->{fieldOPStatus} = $blnStat;
}

method buildRoomString {
       my $userList = $self->buildClientString . '%';
       foreach (values %{$self->{parent}->{clients}}) {
                if ($_->{room} == $self->{room} && $_->{ID} ne $self->{ID}) {
                    $userList .= $_->buildClientString . '%';
                }
       }
       if ($self->{parent}->{servConfig}->{isBot}) {
           $userList .= $self->buildBotString . '%';
       }
       return $userList;
}

method updateEPFPoints($intPoints) {
       return if (!int($intPoints));
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'epfPoints', $intPoints, 'ID', $self->{ID});
       $self->{epfPoints} = $intPoints;
}

method getRoomCount {
       my $intCount = 0;
       foreach (values %{$self->{parent}->{clients}}) {
                if ($_->{room} == $self->{room}) {
                    $intCount++;
                }
       }
       return $intCount;
}

method getOnline($intPID) {
       return if (!int($intPID));
       foreach (values %{$self->{parent}->{clients}}) {
                if ($_->{ID} == $intPID) {
                    return 1;
                }
       }
       return 0;
}

method addIgloo($intIgloo) {
       return if (!int($intIgloo));
       if (!exists($self->{parent}->{modules}->{crumbs}->{iglooCrumbs}->{$intIgloo})) {
	          return $self->sendError(402);
       } elsif (grep /$intIgloo/, @{$self->{ownedIgloos}}) {
	          return $self->sendError(400);
       } elsif ($self->{coins} < $self->{parent}->{modules}->{crumbs}->{iglooCrumbs}->{$intIgloo}->{cost}) {
	          return $self->sendError(401);
       }   
       push(@{$self->{ownedIgloos}}, $intIgloo); 
       $self->updateIglooInventory(join('|', @{$self->{ownedIgloos}}));
       $self->setCoins($self->{coins} - $self->{parent}->{modules}->{crumbs}->{iglooCrumbs}->{$intIgloo}->{cost});
       $self->sendXT(['au', '-1', $intIgloo, $self->{coins}]);
}

method addFurniture($intFurn) {
       return if (!int($intFurn));
       if (!exists($self->{parent}->{modules}->{crumbs}->{furnitureCrumbs}->{$intFurn})) {
           return $self->sendError(402);
       } elsif ($self->{coins} < $self->{parent}->{modules}->{crumbs}->{furnitureCrumbs}->{$intFurn}->{cost}) {
           return $self->sendError(401);
       }
       my $quantity = 1;
       if (exists($self->{ownedFurns}->{$intFurn})) {
           $quantity += $self->{ownedFurns}->{$intFurn};           
       }
       $self->{ownedFurns}->{$intFurn} = $quantity;  
       my $strFurns = join(',', map { $_ . '|' . $self->{ownedFurns}->{$_}; } keys %{$self->{ownedFurns}});
       $self->updateFurnInventory($strFurns);
       $self->setCoins($self->{coins} - $self->{parent}->{modules}->{crumbs}->{furnitureCrumbs}->{$intFurn}->{cost});
       $self->sendXT(['af', '-1', $intFurn, $self->{coins}]);
}

method openIgloo {
       $self->{parent}->{igloos}->{$self->{ID}} = $self->{username};
}

method closeIgloo {
       delete($self->{parent}->{igloos}->{$self->{ID}});
}

method updateFurnInventory($strFurns) {
       $self->{parent}->{modules}->{mysql}->updateTable('igloos', 'ownedFurns', $strFurns, 'ID', $self->{ID});
}

method updateIglooInventory($strIgloos) {
       $self->{parent}->{modules}->{mysql}->updateTable('igloos', 'ownedIgloos', $strIgloos, 'ID', $self->{ID});
}

method updateFurniture($strFurn) {
       $self->{parent}->{modules}->{mysql}->updateTable('igloos', 'furniture', $strFurn, 'ID', $self->{ID});
}

method updateIgloo($intIgloo) {
       return if (!int($intIgloo));
       $self->{igloo} = $intIgloo;
       $self->{parent}->{modules}->{mysql}->updateTable('igloos', 'igloo', $intIgloo, 'ID', $self->{ID});
       $self->sendXT(['ao', '-1', $intIgloo, $self->{coins}]);
}

method updateFloor($intFloor) {
       return if (!int($intFloor));
       if (!exists($self->{parent}->{modules}->{crumbs}->{floorCrumbs}->{$intFloor})) {
           return $self->sendError(402);
       } elsif ($self->{coins} < $self->{parent}->{modules}->{crumbs}->{floorCrumbs}->{$intFloor}->{cost}) {
           return $self->sendError(401);
       }
       $self->{floor} = $intFloor;
       $self->{parent}->{modules}->{mysql}->updateTable('igloos', 'floor', $intFloor, 'ID', $self->{ID});
       $self->setCoins($self->{coins} - $self->{parent}->{modules}->{crumbs}->{floorCrumbs}->{$intFloor}->{cost});
       $self->sendXT(['ag', '-1', $intFloor, $self->{coins}]);
}

method updateMusic($intMusic) {
       return if (!int($intMusic));
       $self->{music} = $intMusic;
       $self->{parent}->{modules}->{mysql}->updateTable('igloos', 'music', $intMusic, 'ID', $self->{ID});
       $self->sendXT(['um', '-1', $intMusic]);
}

method botSay($strMsg) {
       if ($strMsg ne '') {
           $self->sendRoom('%xt%sm%-1%0%' . decode_entities($strMsg) . '%');
       }
}


method addPuffle($puffleType, $puffleName) {
       return if (!int($puffleType) && !$puffleName);
       my $puffleID = $self->{parent}->{modules}->{mysql}->insertData('puffles', ['ownerID', 'puffleName', 'puffleType'], [$self->{ID}, $puffleName, $puffleType]);
       $self->setCoins($self->{coins} - 800);
       return $puffleID . '|' . $puffleName . '|' . $puffleType . '|100|100|100';
}

method getPuffles($userID) {
       my $puffles = '';
       my $arrInfo = $self->{parent}->{modules}->{mysql}->fetchAll("SELECT * FROM puffles WHERE `ownerID` = '$userID'");
       foreach (values @{$arrInfo}) {
                $puffles .= $_->{puffleID} . '|' . $_->{puffleName} . '|' . $_->{puffleType} . '|' . $_->{puffleEnergy} . '|' . $_->{puffleHealth} . '|' . $_->{puffleRest} . '%';
       }
       return substr($puffles, 0, -1);
}

method getPostcards($intPID) {
       return if (!int($intPID));
       my $strCards = '';
       my $arrCards = $self->{parent}->{modules}->{mysql}->fetchAll("SELECT * FROM postcards WHERE `recepient` = '$intPID'");
       my $intCount = 0;
       foreach (values @{$arrCards}) {
                $intCount++;
                $strCards .= $_->{mailerName} . '|' . $_->{mailerID} . '|' . $_->{postcardType} . '|' . $_->{notes} . '|' . $_->{timestamp} . '|' . $intCount . '%';
       }
       return $strCards;
}

method getUnreadPostcards($intPID) {
       return if (!int($intPID));
       my $unreadCount = $self->{parent}->{modules}->{mysql}->countRows("SELECT `isRead` FROM postcards WHERE `recepient` = '$intPID' AND `isRead` = '0'");
       return $unreadCount;
}

method getPostcardCount($intPID) {
       return if (!int($intPID));
       my $intCount = $self->{parent}->{modules}->{mysql}->countRows("SELECT `recepient` FROM postcards WHERE `recepient` = '$intPID'");
       return $intCount;
}

method sendPostcard($recepient, $mailerName = 'Server', $mailerID = 0, $notes = 'Cool', $type = 1, $timestamp = time) {
       my $postcardID = $self->{parent}->{modules}->{mysql}->insertData('postcards', ['recepient', 'mailerName', 'mailerID', 'notes', 'postcardType', 'time'], [$recepient, $mailerName, $mailerID, $notes, $type, $timestamp]);
       return $postcardID;
}

method updateIgnore($strIgnored, $intPID) {
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'ignored', $strIgnored, 'ID', $intPID);
}

method updateBuddies($strBuddies, $intPID) {
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'buddies', $strBuddies, 'ID', $intPID);
}

method updateMute($objClient, $blnMute) {
       return if (!int($blnMute));
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'isMuted', $blnMute, 'ID', $objClient->{ID});
       $objClient->{isMuted} = $blnMute;
}

method updateBan($objClient, $strBan) {
       $self->{parent}->{modules}->{mysql}->updateTable('users', 'isBanned', $strBan, 'ID', $objClient->{ID});
       $objClient->{isBanned} = $strBan;   
}

method updateBanCount($objClient, $intVal) {
       return if (!int($intVal));
       $self->{parent}->{modules}->{mysql}->updateTable('users' , 'banCount', $intVal, 'ID', $objClient->{ID});
       $objClient->{banCount} = $intVal;
}

method DESTROY {
       $self->removePlayer;
       $self->handleBuddyOffline;
       $self->closeIgloo;
}

1;
