//
//	wsram_2k2way_xilinx : Cilinx WS-RAM for 2k per way - 2 way
//
//	$Id: \$
//	mips_repository_id: i_wsram_2k2way_xilinx.v, v 3.4 
//


//      	mips_start_of_legal_notice
//      	**********************************************************************
//		
//	Copyright (c) 2019 MIPS Tech, LLC, 300 Orchard City Dr., Suite 170, 
//	Campbell, CA 95008 USA.  All rights reserved.
//	This document contains information and code that is proprietary to 
//	MIPS Tech, LLC and MIPS' affiliates, as applicable, ("MIPS").  If this 
//	document is obtained pursuant to a MIPS Open license, the sole 
//	licensor under such license is MIPS Tech, LLC. This document and any 
//	information or code therein are protected by patent, copyright, 
//	trademarks and unfair competition laws, among others, and are 
//	distributed under a license restricting their use. MIPS has 
//	intellectual property rights, including patents or pending patent 
//	applications in the U.S. and in other countries, relating to the 
//	technology embodied in the product that is described in this document. 
//	Any distribution release of this document may include or be 
//	accompanied by materials developed by third parties. Any copying, 
//	reproducing, modifying or use of this information (in whole or in part) 
//	that is not expressly permitted in writing by MIPS or an authorized 
//	third party is strictly prohibited.  Any document provided in source 
//	format (i.e., in a modifiable form such as in FrameMaker or 
//	Microsoft Word format) may be subject to separate use and distribution 
//	restrictions applicable to such document. UNDER NO CIRCUMSTANCES MAY A 
//	DOCUMENT PROVIDED IN SOURCE FORMAT BE DISTRIBUTED TO A THIRD PARTY IN 
//	SOURCE FORMAT WITHOUT THE EXPRESS WRITTEN PERMISSION OF, OR LICENSED 
//	FROM, MIPS.  MIPS reserves the right to change the information or code 
//	contained in this document to improve function, design or otherwise.  
//	MIPS does not assume any liability arising out of the application or 
//	use of this information, or of any error or omission in such 
//	information. DOCUMENTATION AND CODE ARE PROVIDED "AS IS" AND ANY 
//	WARRANTIES, WHETHER EXPRESS, STATUTORY, IMPLIED OR OTHERWISE, 
//	INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY, 
//	FITNESS FOR A PARTICULAR PURPOSE OR NON-INFRINGEMENT, ARE EXCLUDED, 
//	EXCEPT TO THE EXTENT THAT SUCH DISCLAIMERS ARE HELD TO BE LEGALLY 
//	INVALID IN A COMPETENT JURISDICTION. Except as expressly provided in 
//	any written license agreement from MIPS or an authorized third party, 
//	the furnishing or distribution of this document does not give recipient 
//	any license to any intellectual property rights, including any patent 
//	rights, that cover the information in this document.  
//	Products covered by, and information or code, contained this document 
//	are controlled by U.S. export control laws and may be subject to the 
//	expert or import laws in other countries. The information contained 
//	in this document shall not be exported, reexported, transferred, or 
//	released, directly or indirectly, in violation of the law of any 
//	country or international law, regulation, treaty, executive order, 
//	statute, amendments or supplements thereto. Nuclear, missile, chemical 
//	weapons, biological weapons or nuclear maritime end uses, whether 
//	direct or indirect, are strictly prohibited.  Should a conflict arise 
//	regarding the export, reexport, transfer, or release of the information 
//	contained in this document, the laws of the United States of America 
//	shall be the governing law.  
//	U.S Government Rights - Commercial software.  Government users are 
//	subject to the MIPS Tech, LLC standard license agreement and applicable 
//	provisions of the FAR and its supplements.
//	MIPS and MIPS Open are trademarks or registered trademarks of MIPS in 
//	the United States and other countries.  All other trademarks referred 
//	to herein are the property of their respective owners.  
//      
//      
//	**********************************************************************
//	mips_end_of_legal_notice
//      
////////////////////////////////////////////////////////////////////////////////

`include "m14k_const.vh"
module i_wsram_2k2way_xilinx(
	clk,
	line_idx,
	rd_str,
	wr_str,
	early_ce, 
	greset,
	wr_mask,
	wr_data,
	rd_data,
	bist_to,
	bist_from);


	/* Inputs */
	input		clk;		// Clock
	input [6:0]	line_idx;	// Read Array Index
	input		rd_str;		// Read Strobe
	input		wr_str;		// Write Strobe
	input [`M14K_MAX_IC_WS-1:0]	wr_mask;	// Write Mask
	input [`M14K_MAX_IC_WS-1:0]	wr_data;		// Data for Tag Write
	input [0:0]	bist_to;

	input		early_ce;
	input		greset;
	/* Outputs */
	output [`M14K_MAX_IC_WS-1:0]	rd_data;		// output from read
	output [0:0]	bist_from;

   	wire [1:0]      ws_rd_data;

	
	assign bist_from[0] = 1'b0;

	assign	rd_data[`M14K_MAX_IC_WS-1:0] = {{7'b0},ws_rd_data[0],{2'b0}};   

 	wire	en;
`ifdef M14K_EARLY_RAM_CE
	assign  en = early_ce;
`else
	assign	en = (wr_str || rd_str);
`endif

	// Need to create a 128 X 1 bit-writeable (duh) cache array
	// All xilinx block rams are 4kbit, so this is a huge waste of ram space
	RAMB4K_S2 i_wsram___inst0 (
		.WE	(wr_str && wr_mask[0]),
		.EN	(en),
		.RST	(1'b0),
		.CLK	(clk),
		.ADDR	({4'b0,line_idx}),
		.DI	({1'b0,wr_data[0]}),
		.DO	(ws_rd_data)
		);

endmodule



