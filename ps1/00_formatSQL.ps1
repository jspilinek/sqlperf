#Strips the parameters from the beginning of SQL text
#Sets $text to the first 128 characters, unless param $fullText equals $true

param (
    [bool]$fullText = $false
)

#$text = "(@P0 nvarchar(4000),@P1 bigint)SELECT 'wt.epm.EPMDocument',A0.administrativeLockIsNull,A0.typeadministrativeLock,A0.classnamekeyC10,A0.idA3C10,A0.authoringAppVersion,A0.classnamekeyB10,A0.idA3B10,A0.blob$entrySetadHocAcl,A0.blob$expressionData,A0.boxExtentsIsNull,A0.AxD10,A0.AyD10,A0.AzD10,A0.BxD10,A0.ByD10,A0.BzD10,A0.checkoutInfoIsNull,A0.statecheckoutInfo,A0.classnamekeycontainerReferen,A0.idA3containerReference,A0.dbKeySize,A0.derived,A0.description,A0.classnamekeydomainRef,A0.idA3domainRef,A0.entrySetadHocAcl,A0.eventSet,A0.expressionData,A0.extentsValid,A0.familyTableStatus,A0.classnamekeyA2folderingInfo,A0.idA3A2folderingInfo,A0.classnamekeyB2folderingInfo,A0.idA3B2folderingInfo,A0.classnamekeyformat,A0.idA3format,A0.hasHangingChange,A0.hasPendingChange,A0.hasResultingChange,A0.hasVariance,A0.indexersindexerSet,A0.inheritedDomain,A0.iopStateinteropInfo,A0.stateinteropInfo,A0.branchIditerationInfo,A0.classnamekeyD2iterationInfo,A0.idA3D2iterationInfo,A0.classnamekeyE2iterationInfo,A0.idA3E2iterationInfo,A0.iterationIdA2iterationInfo,A0.latestiterationInfo,A0.classnamekeyB2iterationInfo,A0.idA3B2iterationInfo,A0.noteiterationInfo,A0.classnamekeyC2iterationInfo,A0.idA3C2iterationInfo,A0.stateiterationInfo,A0.lengthScale,CONVERT(varchar,A0.datelock,120),A0.classnamekeyA2lock,A0.idA3A2lock,A0.notelock,A0.classnamekeymasterReference,A0.idA3masterReference,A0.maximumAllowed,A0.minimumRequired,A0.missingDependents,A0.oneOffVersionIdA2oneOffVersi,A0.classnamekeyA2ownership,A0.idA3A2ownership,A0.placeHolder,A0.referenceControlIsNull,A0.geomRestrE10,A0.geomRestrRecursiveE10,A0.scopeE10,A0.violRestrictionE10,A0.revisionNumber,A0.classnamekeyrootItemReferenc,A0.idA3rootItemReference,A0.securityLabels,A0.atGatestate,A0.classnamekeyA2state,A0.idA3A2state,A0.statestate,A0.teamIdIsNull,A0.classnamekeyteamId,A0.idA3teamId,A0.teamTemplateIdIsNull,A0.classnamekeyteamTemplateId,A0.idA3teamTemplateId,A0.enabledtemplate,A0.templatedtemplate,CONVERT(varchar,A0.createStampA2,120),A0.markForDeleteA2,CONVERT(varchar,A0.modifyStampA2,120),A0.idA2A2,A0.updateCountA2,CONVERT(varchar,A0.updateStampA2,120),A0.branchIdA2typeDefinitionRefe,A0.idA2typeDefinitionReference,A0.verified,A0.versionIdA2versionInfo,A0.versionLevelA2versionInfo,A0.versionSortIdA2versionInfo,A0B.CADName,A0B.authoringApplication,A0B.collapsible,A0B.classnamekeycontainerReferen,A0B.idA3containerReference,A0B.defaultUnit,A0B.docSubType,A0B.docType,A0B.genericType,A0B.globalID,A0B.name,A0B.documentNumber,A0B.classnamekeyorganizationRefe,A0B.idA3organizationReference,A0B.ownerApplication,A0B.series,CONVERT(varchar,A0B.createStampA2,120),A0B.markForDeleteA2,CONVERT(varchar,A0B.modifyStampA2,120),A0B.classnameA2A2,A0B.idA2A2,A0B.updateCountA2,CONVERT(varchar,A0B.updateStampA2,120),A0B.branchIdA2typeDefinitionRefe,A0B.idA2typeDefinitionReference FROM EPMDocument A0 INNER JOIN EPMDocumentMaster A0B ON (A0.idA3masterReference = A0B.idA2A2),CheckoutLink A1 WHERE ((A0.statecheckoutInfo <> @P0)) AND ((A0.markForDeleteA2 = 0) AND (A1.markForDeleteA2 = 0)) AND ((A1.idA3B5 = A0.idA2A2) AND (A1.idA3A5 = @P1))" 

#$text = "(@P0 nvarchar(4000),@P1 bigint)SELECT 'wt.epm.EPMDocument'," 
# $text = "SELECT 'wt.epm.EPMDocument',A0.administrativeLockIsNull,A0.typeadministrativeLock,A0.classnamekeyC10,A0.idA3C10,A0.authoringAppVersion,A0.classnamekeyB10,A0.idA3B10,A0.blob$entrySetadHocAcl,A0.blob$expressionData,A0.boxExtentsIsNull,A0.AxD10,A0.AyD10,A0.AzD10,A0.BxD10,A0.ByD10,A0.BzD10,A0.checkoutInfoIsNull,A0.statecheckoutInfo,A0.classnamekeycontainerReferen,A0.idA3containerReference,A0.dbKeySize,A0.derived,A0.description,A0.classnamekeydomainRef,A0.idA3domainRef,A0.entrySetadHocAcl,A0.eventSet,A0.expressionData,A0.extentsValid,A0.familyTableStatus,A0.classnamekeyA2folderingInfo,A0.idA3A2folderingInfo,A0.classnamekeyB2folderingInfo,A0.idA3B2folderingInfo,A0.classnamekeyformat,A0.idA3format,A0.hasHangingChange,A0.hasPendingChange,A0.hasResultingChange,A0.hasVariance,A0.indexersindexerSet,A0.inheritedDomain,A0.iopStateinteropInfo,A0.stateinteropInfo,A0.branchIditerationInfo,A0.classnamekeyD2iterationInfo,A0.idA3D2iterationInfo,A0.classnamekeyE2iterationInfo,A0.idA3E2iterationInfo,A0.iterationIdA2iterationInfo,A0.latestiterationInfo,A0.classnamekeyB2iterationInfo,A0.idA3B2iterationInfo,A0.noteiterationInfo,A0.classnamekeyC2iterationInfo,A0.idA3C2iterationInfo,A0.stateiterationInfo,A0.lengthScale,CONVERT(varchar,A0.datelock,120),A0.classnamekeyA2lock,A0.idA3A2lock,A0.notelock,A0.classnamekeymasterReference,A0.idA3masterReference,A0.maximumAllowed,A0.minimumRequired,A0.missingDependents,A0.oneOffVersionIdA2oneOffVersi,A0.classnamekeyA2ownership,A0.idA3A2ownership,A0.placeHolder,A0.referenceControlIsNull,A0.geomRestrE10,A0.geomRestrRecursiveE10,A0.scopeE10,A0.violRestrictionE10,A0.revisionNumber,A0.classnamekeyrootItemReferenc,A0.idA3rootItemReference,A0.securityLabels,A0.atGatestate,A0.classnamekeyA2state,A0.idA3A2state,A0.statestate,A0.teamIdIsNull,A0.classnamekeyteamId,A0.idA3teamId,A0.teamTemplateIdIsNull,A0.classnamekeyteamTemplateId,A0.idA3teamTemplateId,A0.enabledtemplate,A0.templatedtemplate,CONVERT(varchar,A0.createStampA2,120),A0.markForDeleteA2,CONVERT(varchar,A0.modifyStampA2,120),A0.idA2A2,A0.updateCountA2,CONVERT(varchar,A0.updateStampA2,120),A0.branchIdA2typeDefinitionRefe,A0.idA2typeDefinitionReference,A0.verified,A0.versionIdA2versionInfo,A0.versionLevelA2versionInfo,A0.versionSortIdA2versionInfo,A0B.CADName,A0B.authoringApplication,A0B.collapsible,A0B.classnamekeycontainerReferen,A0B.idA3containerReference,A0B.defaultUnit,A0B.docSubType,A0B.docType,A0B.genericType,A0B.globalID,A0B.name,A0B.documentNumber,A0B.classnamekeyorganizationRefe,A0B.idA3organizationReference,A0B.ownerApplication,A0B.series,CONVERT(varchar,A0B.createStampA2,120),A0B.markForDeleteA2,CONVERT(varchar,A0B.modifyStampA2,120),A0B.classnameA2A2,A0B.idA2A2,A0B.updateCountA2,CONVERT(varchar,A0B.updateStampA2,120),A0B.branchIdA2typeDefinitionRefe,A0B.idA2typeDefinitionReference FROM EPMDocument A0 INNER JOIN EPMDocumentMaster A0B ON (A0.idA3masterReference = A0B.idA2A2),CheckoutLink A1 WHERE ((A0.statecheckoutInfo <> @P0)) AND ((A0.markForDeleteA2 = 0) AND (A1.markForDeleteA2 = 0)) AND ((A1.idA3B5 = A0.idA2A2) AND (A1.idA3A5 = @P1))" 

#$text

if(($text -isnot [System.DBNull]) -and ($text)){
    Try{
    
        $first2Char = $text.substring(0,2)
        
        if($first2Char -eq "(@"){
            #"Found parameters"
            
            [int]$openParen = 0
            [int]$i = 0
            foreach($char in $text.ToCharArray())
            {
                # "Char: $char"
                if($char -eq "(") {$openParen++}
                elseif($char -eq ")") {$openParen--}
                
                if($openParen -eq 0) { break }
                
                $i++
            }
            if($i+1 -lt $text.length){ 
                $text = $text.substring($i+1)
            }
        }
        
        if(($fullText -eq $false) -and ($text.length -gt 128)){
            $text = $text.substring(0,128)
        }
    }Catch{
        LogException $_.Exception $error[0].ScriptStackTrace "Failed to format SQL:" $text
    }
    #$text
}